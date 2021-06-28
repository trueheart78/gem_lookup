# frozen_string_literal: true

require 'typhoeus'
require 'json'

module GemLookup
  class Requests
    def initialize(batch:, json:)
      @batch = batch
      @json = json || { gems: [] }
    end

    def process
      Typhoeus::Hydra.hydra.tap do |hydra|
        populate_requests hydra: hydra, batch: @batch
      end.run

      @json
    end

    private

    def populate_requests(hydra:, batch:)
      batch.each do |gem_name|
        hydra.queue build_request gem_name: gem_name
      end
    end

    def build_request(gem_name:)
      url = api_url gem_name: gem_name
      Typhoeus::Request.new(url).tap do |request|
        request.on_complete do |response|
          if response.success?
            handle_successful_response json: JSON.parse(response.body, symbolize_names: true)
          else
            handle_failed_response gem_name: gem_name
          end
        end
      end
    end

    def handle_successful_response(json:)
      json[:exists] = true
      @json[:gems].push json
    end

    def handle_failed_response(gem_name:)
      json = { name: gem_name, exists: false }
      @json[:gems].push json
    end

    def api_url(gem_name:)
      "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    end
  end
end
