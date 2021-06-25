# frozen_string_literal: true

require 'colorize'

module GemLookup
  class RubyGems
    def initialize(gems)
      @gem_list = gems
      @flags = []
      @display_mode = :emoji
      @continue = true
    end

    def find_all
      prepare_list if valid?

      return unless continue?

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
      error message: "Invalid display mode [#{e.message}]"
    end

    def handle_flags
      return unless @flags.any?

      check_flags
    rescue GemLookup::Errors::UnsupportedFlag => e
      error message: "Unsupported flag [#{e.message}]"
    rescue GemLookup::Errors::UnsupportedFlags => e
      error message: "Unsupported flags [#{e.message}]"
    end

    # rubocop:disable Metrics/MethodLength
    def check_flags
      if Flags.supported?(:help, flags: @flags)
        Help.display exit_code: 0
        @continue = false
      elsif Flags.supported?(:version, flags: @flags)
        Help.version exit_code: 0
        @continue = false
      elsif Flags.supported?(:wordy, flags: @flags)
        @display_mode = :wordy
      elsif Flags.supported?(:json, flags: @flags)
        @display_mode = :json
      elsif Flags.unsupported(flags: @flags)
        @continue = false
      end
    end
    # rubocop:enable Metrics/MethodLength

    def continue?
      @continue
    end

    def valid?
      @gem_list.any?
    end

    def display_help!
      Help.display exit_code: 1
    end

    def error(message:)
      puts "=> Error: #{message}".red
      exit 1
    end
  end
end
