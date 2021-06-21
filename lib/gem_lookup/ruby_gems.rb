# frozen_string_literal: true

module GemLookup
  class RubyGems
    def initialize(gems)
      @gem_list = gems
      @flags = []
      @batches = []
      @display_mode = :standard
      @json = { gems: [] }
    end

    def find_all
      exit_early if @gem_list.empty?
    end

    private

    def exit_early
      Help.display exit_code: 1
    end
  end
end
