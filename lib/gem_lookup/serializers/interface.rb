# frozen_string_literal: true

module GemLookup
  module Serializers::Interface
    class << self
      def display
        raise 'Must be implemented by sub-class'
      end

      def gem_count
        raise 'Must be implemented by sub-class'
      end
    end
  end
end
