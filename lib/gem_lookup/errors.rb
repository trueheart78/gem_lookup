# frozen_string_literal: true

module GemLookup
  module Errors
    class InvalidDisplayMode < StandardError; end

    class UndefinedInterfaceMethod < StandardError; end

    class UnsupportedFlags < StandardError; end

    class UnsupportedFlag < StandardError; end
  end
end
