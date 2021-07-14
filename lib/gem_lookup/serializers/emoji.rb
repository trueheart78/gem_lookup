# frozen_string_literal: true

require 'colorize'
require 'date'

module GemLookup
  module Serializers
    class Emoji < Interface
      class << self
        # Outputs the emoji-based format for the gem
        # @param json [Hash] the json hash, with symbolized keys.
        def display(json:)
          if json[:timeout]
            puts timed_out(gem_name: json[:name])
          elsif json[:exists]
            puts gem_details(json: json)
          else
            puts not_found(gem_name: json[:name])
          end
        end

        # Outputs the number of gems being queried.
        # @param num [Numeric] the number of gems.
        def gem_count(num:)
          puts "=> 🤔 #{num} gems".light_cyan
        end

        # Outputs the current batch and total number of batches
        # @param num [Numeric] the current batch number.
        # @param total [Numeric] the total number of batches.
        def batch_iterator(num:, total:)
          puts "=> 🧺 #{num} of #{total}".yellow
        end

        # Outputs the list of gems being looked up from the batch.
        # @param batch [Array] the array of gems.
        def querying(batch:)
          puts "=> 🔎 #{batch.join(", ")}".light_yellow
        end

        # Returns if the serializer is meant to be used to stream content.
        # @return [Boolean] whether the serializer is meant for streaming content.
        def streaming?
          true
        end

        private

        # rubocop:disable Metrics/AbcSize
        # Returns the emoji-based format for the gem
        # @param json [Hash] the json hash, with symbolized keys.
        def gem_details(json:)
          [].tap do |output|
            output.push "=> 💎 #{json[:name]} is at #{json[:version]}".green
            output.push "==> 📅 #{convert_date(date: json[:version_created_at])}"
            output.push "==> 🧭 #{json[:project_uri]}"
            output.push "==> 🏠 #{json[:homepage_uri]}"
            output.push source_code(source_code_uri: json[:source_code_uri])
            output.push changelog(changelog_uri: json[:changelog_uri])
            output.push mailing_list(mailing_list_uri: json[:mailing_list_uri])
          end.join "\n"
        end
        # rubocop:enable Metrics/AbcSize

        # Generates the "Source Code" string
        # @param source_code_uri [String] the source code uri.
        # @return [String] the repository string.
        def source_code(source_code_uri:)
          if source_code_uri && !source_code_uri.empty?
            "==> 🔗 #{source_code_uri}"
          else
            '==> 🔗 Unavailable'.light_red
          end
        end

        # Generates the "changelog" string
        # @param changelog_uri [String] the changelog uri.
        # @return [String] the changelog string.
        def changelog(changelog_uri:)
          if changelog_uri && !changelog_uri.empty?
            "==> 📑 #{changelog_uri}".light_cyan
          else
            '==> 📑 Unavailable'.light_red
          end
        end

        # Generates the "mailing list" string
        # @param mailing_list_uri [String] the mailing list uri.
        # @return [String] the mailing list string.
        def mailing_list(mailing_list_uri:)
          if mailing_list_uri && !mailing_list_uri.empty?
            "==> 💌 #{mailing_list_uri}".light_cyan
          else
            '==> 💌 Unavailable'.light_red
          end
        end

        # Generates the "gem lookup timed out" string
        # @param gem_name [String] the name of the gem that the lookup timed out on.
        # @return [String] the gem lookup timed out string.
        def timed_out(gem_name:)
          "=> 💎 #{gem_name} lookup timed out".red
        end

        # Generates the "gem not found" string
        # @param gem_name [String] the name of the gem that was not found.
        # @return [String] the gem not found string.
        def not_found(gem_name:)
          "=> 💎 #{gem_name} not found".red
        end

        # Parses the passed date/datetime string into the desired format, aka "November 13, 2014".
        # @param date [String] the date to be parsed.
        # @return [String] the formatted date.
        def convert_date(date:)
          Date.parse(date).strftime '%B %-d, %Y'
        end
      end
    end
  end
end
