#!/usr/bin/env ruby

# frozen_string_literal: true

# bundler inline to get the right gems
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'colorize'
  gem 'pry'
  gem 'typhoeus'
end

require 'date'
require 'json'

class RubyGems
  MAX_REQUESTS_PER_SECOND = 10

  def initialize(gems)
    @gem_list = gems

    exit_early unless @gem_list.any?
    cull_list if limit_list?
  end

  def lookup
    puts "=> 🕵️ Looking up: #{@gem_list.join(', ')}"
    @hydra = Typhoeus::Hydra.hydra
    populate_requests
    @hydra.run
  end

  private

  def populate_requests
    @gem_list.each do |gem_name|
      @hydra.queue build_request gem_name
    end
  end

  def build_request(gem_name)
    url = api_url gem_name
    Typhoeus::Request.new(url).tap do |request|
      request.on_complete do |response|
        if response.code == 200
          puts display_json JSON.parse(response.body, symbolize_names: true)
        else
          puts not_found(gem_name)
        end
      end
    end
  end

  def api_url(gem_name)
    "https://rubygems.org/api/v1/gems/#{gem_name}.json"
  end

  def display_json(json)
    [].tap do |output|
      output.push "=> 💎 #{json[:name]} is at #{json[:version]}".green
      output.push "==> 📅 #{convert_date(json[:version_created_at])}"
      output.push "==> 🏠 #{json[:homepage_uri]}"
      output.push "==> ℹ️ #{json[:source_code_uri]}" if json[:source_code_uri]
      output.push changelog(changelog_uri: json[:changelog_uri])
    end.join "\n"
  end

  def changelog(changelog_uri:)
    return "==> 📑 #{changelog_uri}".blue if changelog_uri

    '==> 🚫 No changelog'.red
  end

  def not_found(gem_name)
    "=> 😢 #{gem_name} not found".red
  end

  # Returns date times as date, aka "November 13, 2014"
  def convert_date(date_and_time)
    Date.parse(date_and_time).strftime '%B %-d, %Y'
  end

  def limit_list?
    @gem_list.size > MAX_REQUESTS_PER_SECOND
  end

  # limits the gem list to the first ten passed in
  def cull_list
    puts '=> ⚠️ Limited to the first 10 gems due to rate limiting'
    @gem_list = @gem_list[0...MAX_REQUESTS_PER_SECOND]
  end

  def exit_early
    puts 'Please enter some gems 💎'
    exit 1
  end
end

RubyGems.new(ARGV).lookup
