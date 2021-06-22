# frozen_string_literal: true

require 'typhoeus'
require 'colorize'
require 'date'
require 'json'

module GemLookup
  class Gems
    def initialize(gem_list, display_mode: :standard)
      @gem_list = gem_list
      @batches = []
      @display_mode = display_mode
      @json = { gems: [] }
    end

    def process
      validate_display_mode!

      batch_gems
      process_batches
    end

    private

    def process_batches
      say "=> ✨ Gems: #{@gem_list.size}" if @gem_list.size > 1

      @batches.each_with_index {|batch, index| process_batch batch: batch, index: index }

      puts JSON.pretty_generate(@json) if json?
    end

    def process_batch(batch:, index:)
      say "=> 🧺 Batch: #{index + 1} of #{@batches.size}".magenta if batch_mode?
      say "=> 🔎 Looking up: #{batch.join(", ")}"

      make_requests batch: batch

      sleep 1 if batch_mode?
    end

    def make_requests(batch:)
      Typhoeus::Hydra.hydra.tap do |hydra|
        populate_requests hydra: hydra, batch: batch
      end.run
    end

    def populate_requests(hydra:, batch:)
      batch.each do |gem_name|
        hydra.queue build_request gem_name: gem_name
      end
    end

    def build_request(gem_name:)
      url = api_url gem_name: gem_name
      Typhoeus::Request.new(url).tap do |request|
        request.on_complete do |response|
          if response.code == 200
            handle_successful_response json: JSON.parse(response.body, symbolize_names: true)
          else
            handle_failed_response gem_name: gem_name
          end
        end
      end
    end

    def handle_successful_response(json:)
      if json?
        json[:exists] = true
        @json[:gems].push json
      else
        say display_json(json: json)
      end
    end

    def handle_failed_response(gem_name:)
      if json?
        json = { name: gem_name, exists: false }
        @json[:gems].push json
      else
        say not_found(gem_name: gem_name)
      end
    end

    def api_url(gem_name:)
      "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    end

    # rubocop:disable Metrics/AbcSize
    def display_json(json:)
      [].tap do |output|
        output.push "=> 💎 #{json[:name]} is at #{json[:version]}".green
        output.push "==> 📅 #{convert_date(date: json[:version_created_at])}"
        output.push "==> 🏠 #{json[:homepage_uri]}"
        output.push "==> 🔗 #{json[:source_code_uri]}" if json[:source_code_uri]
        output.push changelog(changelog_uri: json[:changelog_uri])
      end.join "\n"
    end
    # rubocop:enable Metrics/AbcSize

    def changelog(changelog_uri:)
      return "==> 📑 #{changelog_uri}".light_blue if changelog_uri

      '==> 📑 No changelog'.red
    end

    def not_found(gem_name:)
      "=> 💎 #{gem_name} not found".red
    end

    # Returns date times as date, aka "November 13, 2014"
    def convert_date(date:)
      Date.parse(date).strftime '%B %-d, %Y'
    end

    def validate_display_mode!
      return if %i[standard json].include? @display_mode

      puts "=> Error: Invalid display mode [#{@display_mode}]".red
      exit 1
    end

    def batch_gems
      gems = @gem_list.dup

      @batches.push gems.shift(RateLimit.number) while gems.any?
    end

    def batch_mode?
      @batches.size > 1
    end

    def json?
      @display_mode == :json
    end

    def say(string)
      return if json?

      puts string
    end
  end
end
