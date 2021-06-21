# frozen_string_literal: true

module GemLookup
  class Help
    # @return [Numeric] the spacing for output options
    OUTPUT_OPTION_SPACING = 21

    class << self
      def content
        <<~HELP

          Usage: gems GEMS

            Retrieves gem-related information from https://rubygems.org

          Example: gems rails rspec

          This application's purpose is to make working with with RubyGems.org easier. 💖
          It uses the RubyGems public API to perform lookups, and parses the JSON response
          body to provide details about the most recent version, as well as links to
          the home page, source code, and changelog.

          Feel free to pass in as many gems that you like, as it makes requests in
          parallel. There is a rate limit, #{rate_limit_num}/sec. If it detects the amount of gems it
          has been passed is more than the rate limit, the application will run in Batch
          mode, and introduce a one second delay between batch lookups.

          #{options}

          Rate limit documentation: #{rate_limit_url}
        HELP
      end

      def display(exit_code: nil)
        puts content

        exit exit_code unless exit_code.nil?
      end

      private

      def rate_limit_num
        RateLimit::MAX_REQUESTS_PER_SECOND
      end

      def rate_limit_url
        RateLimit::RATE_LIMIT_DOCUMENTATION_URL
      end

      def options
        <<~OPTIONS.chomp
          Output Options:
          #{flag_output}
        OPTIONS
      end

      # rubocop:disable Metrics/AbcSize
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
