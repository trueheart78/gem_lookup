# frozen_string_literal: true

module GemLookup
  class Help
    # @return [Numeric] the spacing for output options
    OUTPUT_OPTION_SPACING = 21

    class << self
      # Outputs the generated content.
      # @param exit_code [Numeric, nil] the exit code (if any) to exit with.
      def display(exit_code: nil)
        puts documentation

        exit exit_code unless exit_code.nil?
      end

      # Outputs the gem name and current gem version.
      # @param exit_code [Numeric, nil] the exit code (if any) to exit with.
      def version(exit_code: nil)
        puts "#{NAME} #{VERSION}"

        exit exit_code unless exit_code.nil?
      end

      # Generates the help documentation.
      # @return [String] the help documentation.
      def documentation
        <<~HELP

          Usage: gems [OPTIONS] GEMS

            Retrieves gem-related information from https://rubygems.org

          Example: gems -j rails rspec

          This application's purpose is to make working with with RubyGems.org easier. 💖
          It uses the RubyGems public API to perform lookups, and parses the JSON response
          body to provide details about the most recent version, as well as links to
          the home page, source code, changelog, and mailing list.

          Feel free to pass in as many gems that you like, as it makes requests in
          parallel. There is a rate limit, #{RateLimit.number}/sec. If it detects the amount of gems it
          has been passed is more than the rate limit, the application will run in Batch
          mode, and introduce a one second delay between batch lookups.

          #{options}

          Rate limit documentation: #{RateLimit.documentation_url}
        HELP
      end

      private

      # Generates an Output Options string that includes the supported flag details.
      # @return [String] the supported output options.
      def options
        <<~OPTIONS.chomp
          Output Options:
          #{flag_output}
        OPTIONS
      end

      # rubocop:disable Metrics/AbcSize
      # Generates a formatted string that displays the supported flag details.
      # @return [String] the supported flags and their details.
      def flag_output
        [].tap do |output|
          Flags.supported.keys.sort.each do |key|
            matches = Flags.supported[key][:matches].join ' '
            spaces = ' ' * (OUTPUT_OPTION_SPACING - matches.length)
            output.push "  #{matches}#{spaces}#{Flags.supported[key][:desc]}"
          end
        end.join "\n"
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
