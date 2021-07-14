# frozen_string_literal: true

module GemLookup
  module Serializers
    class Interface
      class << self
        # rubocop:disable Lint/UnusedMethodArgument

        # Should be overriden to output the desired output format for the gem
        # @param json [Hash] the json hash, with symbolized keys.
        def display(json:)
          not_implemented __method__, params: %w[:json]
        end

        # Should be overriden to output the number of gems being queried.
        # @param num [Numeric] the number of gems.
        def gem_count(num:)
          not_implemented __method__, params: %w[:num]
        end

        # Should be overriden to output the current batch and total number of batches
        # @param num [Numeric] the current batch number.
        # @param total [Numeric] the total number of batches.
        def batch_iterator(num:, total:)
          not_implemented __method__, params: %w[:num :total]
        end

        # Should be overridden to output the list of gems being looked up from the batch.
        # @param batch [Array] the array of gems.
        def querying(batch:)
          not_implemented __method__, params: %w[:batch]
        end

        # Should be overriden to return if the serializer is meant to be used to stream content.
        # @return [Boolean] whether the serializer is meant for streaming content.
        def streaming?
          not_implemented __method__
        end
        # rubocop:enable Lint/UnusedMethodArgument

        private

        def not_implemented(method, params: [])
          required = params.any? ? " with params (#{params.join(", ")})" : ''
          raise GemLookup::Errors::UndefinedInterfaceMethod,
                "Class method .#{method}#{required} must be implemented by sub-class"
        end
      end
    end
  end
end
