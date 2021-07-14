# frozen_string_literal: true

module Support
  module Coverage
    def self.included(_klass)
      require 'simplecov'

      SimpleCov.minimum_coverage 99

      SimpleCov.start do
        add_filter '/spec/'
      end
    end
  end
end
