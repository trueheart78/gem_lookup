# frozen_string_literal: true

module GemLookup
  module RateLimit
    # @return [Numeric] the max requests that can be made per interval.
    MAX_REQUESTS_PER_INTERVAL = 10

    # @return [Numeric] the frequency interval, in seconds.
    FREQUENCY_INTERVAL_IN_SECONDS = 1

    # @return [String] the url that documents the rate limit
    RATE_LIMIT_DOCUMENTATION_URL = 'https://guides.rubygems.org/rubygems-org-rate-limits/'

    class << self
      # Calls MAX_REQUESTS_PER_SECOND.
      # @return [Numeric] the max requests that can be made per interval.
      def number
        MAX_REQUESTS_PER_INTERVAL
      end

      # Calls FREQUENCY_INTERVAL_IN_SECONDS
      # @return [Numeric] the frequency interval, in seconds.
      def interval
        FREQUENCY_INTERVAL_IN_SECONDS
      end

      # Calls RATE_LIMIT_DOCUMENTATION_URL.
      # @return [String] the url that documents the rate limit.
      def documentation_url
        RATE_LIMIT_DOCUMENTATION_URL
      end
    end
  end
end
