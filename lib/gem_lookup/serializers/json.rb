# frozen_string_literal: true

require 'json'

module GemLookup
  module Serializers::Json
    class << self
      def display(json:)
        puts JSON.pretty_generate json
      end

      def streaming?
        false
      end
    end
  end
end
