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

# rubocop:disable Metrics/ClassLength
class RubyGems
  VERSION = '0.6.5'
  MAX_REQUESTS_PER_SECOND = 10
  RATE_LIMIT_DOCUMENTATION_URL = 'https://guides.rubygems.org/rubygems-org-rate-limits/'

  def initialize(gems)
    @gem_list = gems
    @flags = []
    @batches = []
    @display_mode = :standard
    @json = { gems: [] }
  end

  def lookup
    exit_early if @gem_list.empty?

    prepare_list
    process_batches
  end

  class << self
    def version(exit_application: false)
      puts "version #{VERSION}"
      exit 0 if exit_application
    end

    def help(exit_application: false)
      puts <<~HELP

        #{usage}

        This application's purpose is to make working with with RubyGems.org easier. 💖
        It uses the RubyGems public API to perform lookups, and parses the JSON response
        body to provide details about the most recent version, as well as links to
        the home page, source code, and changelog.

        Feel free to pass in as many gems that you like, as it makes requests in
        parallel. There is a rate limit, #{MAX_REQUESTS_PER_SECOND}/sec. If it detects the amount of gems it
        has been passed is more than the rate limit, the application will run in Batch
        mode, and introduce a one second delay between batch lookups.

        #{options}

        Rate limit documentation: #{RATE_LIMIT_DOCUMENTATION_URL}
      HELP
      exit 0 if exit_application
    end

    def flags
      {
        help:    { matches: %w[-h --help], desc: 'Display the help screen.' },
        version: { matches: %w[-v --version], desc: 'Display version information.' },
        json:    { matches: %w[-j --json], desc: 'Display the raw JSON.' }
      }
    end

    private

    def usage
      file_name = __FILE__.start_with?('./') ? __FILE__ : __FILE__.split('/').last

      <<~USAGE.chomp
        Usage: #{file_name} GEMS

          Retrieves gem-related information from https://rubygems.org

        Example: #{file_name} rails rspec
      USAGE
    end

    def options
      <<~OPTIONS.chomp
        Output Options:
          -h --help            Display the help screen.
          -j --json            Display the raw JSON.
          -v --version         Display version information.
      OPTIONS
    end
  end

  private

  def prepare_list
    format_list
    detect_flags
    handle_flags
    batch_gems
  end

  def detect_flags
    @flags = @gem_list.select {|g| g[0] == '-' }
    @gem_list -= @flags if @flags.any?
  end

  def handle_flags
    return unless @flags.any?

    if flag? :help
      self.class.help exit_application: true
    elsif flag? :version
      self.class.version exit_application: true
    elsif flag? :json
      @display_mode = :json
    else
      unsupported_flags
    end
  end

  def flag?(type)
    return false if type.nil?

    type = type.to_sym
    return false unless self.class.flags.key? type

    self.class.flags[type][:matches].each do |flag|
      return true if @flags.include? flag
    end

    false
  end

  def json?
    @display_mode == :json
  end

  def unsupported_flags
    flag_word = @flags.size > 1 ? 'flags' : 'flag'
    puts "=> Error: Unsupported #{flag_word} [#{@flags.join(', ')}]".red
    exit 1
  end

  def process_batches
    say "=> ✨ Gems: #{@gem_list.size}" if @gem_list.size > 1

    @batches.each_with_index {|batch, index| process_batch batch: batch, index: index }

    puts JSON.pretty_generate(@json) if json?
  end

  def process_batch(batch:, index:)
    say "=> 🧺 Batch: #{index + 1} of #{@batches.size}".magenta if batch_mode?
    say "=> 🔎 Looking up: #{batch.join(', ')}"

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

  def format_list
    @gem_list.map!(&:downcase).uniq!
  end

  def batch_gems
    gems = @gem_list.dup

    @batches.push gems.shift(MAX_REQUESTS_PER_SECOND) while gems.any?
  end

  def batch_mode?
    @batches.size > 1
  end

  def say(string)
    return if json?

    puts string
  end

  def exit_early
    self.class.help
    exit 1
  end
end

RubyGems.new(ARGV).lookup
# rubocop:enable Metrics/ClassLength
