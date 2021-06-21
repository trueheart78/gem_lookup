# frozen_string_literal: true

module GemLookup
  class RubyGems
    def initialize(gems)
      @gem_list = gems
      @flags = []
      @batches = []
      @display_mode = :standard
      @json = { gems: [] }
    end

    def find_all
      exit_early if @gem_list.empty?

      prepare_list
      # process_batches
    end

    private

    def prepare_list
      format_list
      detect_flags
      handle_flags
      batch_gems
    end

    def detect_flags
      @flags = @gem_list.select {|g| g[0] == '-' }
      @gem_list -= @flags if @flags.any?
    end

    def format_list
      @gem_list.map!(&:downcase).uniq!
    end

    def batch_gems
      gems = @gem_list.dup

      @batches.push gems.shift(MAX_REQUESTS_PER_SECOND) while gems.any?
    end

    def batch_mode?
      @batches.size > 1
    end

    def say(string)
      return if json?

      puts string
    end

    def handle_flags
      return unless @flags.any?

      if Flags.supported?(:help, flags: @flags)
        Help.display exit_code: 0
      elsif Flags.supported?(:version, flags: @flags)
        Help.version exit_code: 0
      elsif Flags.supported?(:json, flags: @flags)
        @display_mode = :json
      else
        Flags.unsupported flags: @flags
      end
    end

    def exit_early
      Help.display exit_code: 1
    end
  end
end
