# frozen_string_literal: true

require 'forwardable'

module GemLookup
  class Gems
    extend Forwardable

    def_delegators :@serializer, :display, :batch_iterator, :gem_count, :querying, :streaming?

    def initialize(gem_list, display_mode: :emoji)
      @gem_list = gem_list
      @batches = []
      @display_mode = display_mode
      @json = { gems: [] }
      @serializer = nil
    end

    def process
      detect_serializer
      batch_gems
      process_batches
    end

    private

    def process_batches
      display_gem_count

      @batches.each_with_index {|batch, index| process_batch batch: batch, index: index }

      display(json: @json) unless streaming?
    end

    def process_batch(batch:, index:)
      display_batch_details(index + 1, @batches.size, batch)

      make_requests batch: batch
      display_results

      sleep RateLimit.interval if batch_mode?
    end

    def make_requests(batch:)
      @json = Requests.new(batch: batch, json: @json).process
    end

    def display_gem_count
      return unless streaming?

      gem_count(@gem_list.size) if @gem_list.size > 1
    end

    def display_batch_details(num, total, batch)
      return unless streaming?

      batch_iterator(num, total) if batch_mode?
      querying(batch)
    end

    def display_results
      return unless streaming?

      display(json: @json[:gems].shift) while @json[:gems].any?
    end

    def detect_serializer
      @serializer = case @display_mode
                    when :classic
                      Serializers::Classic
                    when :json
                      Serializers::Json
                    when :emoji
                      Serializers::Emoji
                    end

      invalid_display_mode! if @serializer.nil?
    end

    def invalid_display_mode!
      raise GemLookup::Errors::InvalidDisplayMode, @display_mode
    end

    def batch_gems
      gems = @gem_list.dup

      @batches.push gems.shift(RateLimit.number) while gems.any?
    end

    def batch_mode?
      @batches.size > 1
    end
  end
end
