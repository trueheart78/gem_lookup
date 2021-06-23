# frozen_string_literal: true

require 'colorize'

module GemLookup
  class Flags
    class << self
      # Returns the supported flags.
      # @return [Hash] the supported flags.
      def supported
        {
          help:    { matches: %w[-h --help], desc: 'Display the help screen.' },
          version: { matches: %w[-v --version], desc: 'Display version information.' },
          json:    { matches: %w[-j --json], desc: 'Bulk the output results as raw JSON.' },
          classic: { matches: %w[-c --classic], desc: 'Stream the output using only words.' }
        }
      end

      # Checks to see if any flags passed in match those defined by the type.
      # @param type [Symbol] the type of flag (`:help`, `:version`, etc).
      # @param flags [Array] an array that may or may not contain a supported flag.
      # @return [Boolean] whether the flags passed in contain a flag supported by type.
      def supported?(type, flags: [])
        return false if type.nil?
        return false if flags.empty?

        type = type.to_sym
        return false unless supported.key? type

        supported[type][:matches].each do |flag|
          return true if flags.include? flag
        end

        false
      end

      # Outputs the unsupported flags and exits with a code of 1.
      # @param flags [Array] the list of unsupported flags.
      def unsupported(flags:)
        flags = flags.compact.reject(&:empty?)
        return false if flags.empty?

        flag_word = flags.size > 1 ? 'flags' : 'flag'
        puts "=> Error: Unsupported #{flag_word} [#{flags.join(", ")}]".red
        exit 1
      end
    end
  end
end
