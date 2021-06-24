# frozen_string_literal: true

require 'json'

module GemLookup
  module Serializers::Json
    class << self
      # Outputs the json (in a pretty format) for the gem
      # @param json [Hash] the json hash.
      def display(json:)
        puts JSON.pretty_generate json
      end

      # Returns whether the serializer is meant to be used to stream content.
      # @return [Boolean] whether the serializer is meant for streaming content.
      def streaming?
        false
      end
    end
  end
end
