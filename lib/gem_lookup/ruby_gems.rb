# frozen_string_literal: true

require 'colorize'

module GemLookup
  class RubyGems
    # Creates a new instance of RubyGems.
    # @param gems [Array] an array of gems and/or flags.
    def initialize(gems)
      @gem_list = gems
      @flags = []
      @display_mode = :emoji
      @continue = true
    end

    # Handles the preparation and processing of the gems and/or flags.
    def find_all
      format_list
      process_flags if valid?

      return unless continue?

      process_gems if valid?
      display_help! unless valid?
    end

    private

    # Processes the detection and handling of flags.
    def process_flags
      detect_flags
      handle_flags
    end

    # Looks for strings that start with a dash and marks them as flags, and removes them from the
    # gem list.
    def detect_flags
      @flags = @gem_list.select {|g| g[0] == '-' }
      @gem_list -= @flags
    end

    # Lower-cases the entire gem list, and then removes duplicate entries.
    def format_list
      @gem_list.map!(&:downcase).uniq!
    end

    # Creates a new GemLookup::Gems instance and calls #process.
    def process_gems
      Gems.new(@gem_list, display_mode: @display_mode).process
    rescue GemLookup::Errors::InvalidDisplayMode => e
      error message: "Invalid display mode [#{e.message}]"
    end

    # Calls the #check_flags method if there are any flag entries.
    def handle_flags
      return unless @flags.any?

      check_flags
    rescue GemLookup::Errors::UnsupportedFlag => e
      error message: "Unsupported flag [#{e.message}]"
    rescue GemLookup::Errors::UnsupportedFlags => e
      error message: "Unsupported flags [#{e.message}]"
    end

    # Looks through the flags and calls GemLookup::Flags to assist, and either calls GemLookup::Help
    # or sets the display mode, where appropriate.
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

    # If the lookup process should continue.
    # @return [Boolean] whether to continue the lookup process or not.
    def continue?
      @continue
    end

    # If the gem list is valid.
    # @return [Boolean] whether there are any entries in the gem list.
    def valid?
      @gem_list.any?
    end

    # Calls the GemLookup::Help.display method and exits with an exit code of 1.
    def display_help!
      Help.display exit_code: 1
    end

    # Outputs the passed in message in a standard error format, in red, and exits with an exit code
    # of 1.
    # @param message [String] the error message to present.
    def error(message:)
      puts "=> Error: #{message}".red
      exit 1
    end
  end
end
