# frozen_string_literal: true

module GemLookup
  module Serializers
    class Interface
      class << self
        # rubocop:disable Lint/UnusedMethodArgument
        def display(json:)
          not_implemented __method__, params: %w[:json]
        end

        def gem_count(num:)
          not_implemented __method__, params: %w[:num]
        end

        def batch_iterator(num:, total:)
          not_implemented __method__, params: %w[:num :total]
        end

        def querying(batch:)
          not_implemented __method__, params: %w[:batch]
        end

        def streaming?
          not_implemented __method__
        end
        # rubocop:enable Lint/UnusedMethodArgument

        private

        def not_implemented(method, params: [])
          required = params.any? ? " with params (#{params.join(", ")})" : ''
          raise GemLookup::Errors::UndefinedInterfaceMethod,
                "Method #{method}#{required} must be implemented by sub-class"
        end
      end
    end
  end
end
