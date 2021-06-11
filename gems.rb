#!/usr/bin/env ruby

# frozen_string_literal: true

# bundler inline to get the right gems
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'colorize'
  gem 'typhoeus'
end

require 'date'
require 'json'

class RubyGems
  MAX_REQUESTS_PER_SECOND = 10

  def initialize(gems:)
    @gem_list = gems
    @batches = []
  end

  def lookup
    exit_early unless @gem_list.any?
    prepare

    puts "=> #️⃣ Gems: #{@gem_list.size}"
    puts "=> ⚙️ Mode: #{mode.capitalize}"

    process_batches
  end

  private

  def prepare
    format_list
    batch_gems
  end

  def process_batches
    @batches.each_with_index do |batch, index|
      puts "=> 🧺 Batch: #{index + 1} of #{@batches.size}".magenta if batch_mode?
      puts "=> 🕵️ Looking up: #{batch.join(', ')}"

      make_requests batch: batch

      sleep 1 if batch_mode?
    end
  end

  def make_requests(batch:)
    @hydra = Typhoeus::Hydra.hydra
    populate_requests batch: batch
    @hydra.run
  end

  def populate_requests(batch:)
    batch.each do |gem_name|
      @hydra.queue build_request gem_name: gem_name
    end
  end

  def build_request(gem_name:)
    url = api_url gem_name: gem_name
    Typhoeus::Request.new(url).tap do |request|
      request.on_complete do |response|
        if response.code == 200
          puts display_json(json: JSON.parse(response.body, symbolize_names: true))
        else
          puts not_found(gem_name: gem_name)
        end
      end
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
      output.push "==> ℹ️ #{json[:source_code_uri]}" if json[:source_code_uri]
      output.push changelog(changelog_uri: json[:changelog_uri])
    end.join "\n"
  end
  # rubocop:enable Metrics/AbcSize

  def changelog(changelog_uri:)
    return "==> 📑 #{changelog_uri}".blue if changelog_uri

    '==> 🚫 No changelog'.red
  end

  def not_found(gem_name:)
    "=> 💎 #{gem_name} not found".red
  end

  # Returns date times as date, aka "November 13, 2014"
  def convert_date(date:)
    Date.parse(date).strftime '%B %-d, %Y'
  end

  def format_list
    @gem_list.map!(&:downcase).uniq!
  end

  def batch_gems
    gems = @gem_list.dup

    @batches.push gems.shift(MAX_REQUESTS_PER_SECOND) while gems.any?
  end

  def batch_mode?
    mode == :batch
  end

  def mode
    @mode ||= @batches.size > 1 ? :batch : :standard
  end

  def exit_early
    puts 'Please enter some gems 💎'
    exit 1
  end
end

RubyGems.new(gems: ARGV).lookup
