# frozen_string_literal: true

require 'colorize'

module GemLookup
  class RubyGems
    def initialize(gems)
      @gem_list = gems
      @flags = []
      @display_mode = :emoji
    end

    def find_all
      prepare_list if valid?
      process_gems if valid?

      display_help! unless valid?
    end

    private

    def prepare_list
      format_list
      detect_flags
      handle_flags
    end

    def detect_flags
      @flags = @gem_list.select {|g| g[0] == '-' }
      @gem_list -= @flags if @flags.any?
    end

    def format_list
      @gem_list.map!(&:downcase).uniq!
    end

    def process_gems
      Gems.new(@gem_list, display_mode: @display_mode).process
    rescue GemLookup::Errors::InvalidDisplayMode => e
      puts "=> Error: Invalid display mode [#{e.message}]".red
      exit 1
    end

    def handle_flags
      return unless @flags.any?

      if Flags.supported?(:help, flags: @flags)
        Help.display exit_code: 0
      elsif Flags.supported?(:version, flags: @flags)
        Help.version exit_code: 0
      elsif Flags.supported?(:wordy, flags: @flags)
        @display_mode = :wordy
      elsif Flags.supported?(:json, flags: @flags)
        @display_mode = :json
      else
        Flags.unsupported flags: @flags
      end
    end

    def valid?
      @gem_list.any?
    end

    def display_help!
      Help.display exit_code: 1
    end
  end
end
