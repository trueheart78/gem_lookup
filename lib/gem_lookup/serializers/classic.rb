# frozen_string_literal: true

require 'colorize'
require 'json'

module GemLookup
  module Serializers::Classic
    class << self
      # Outputs the emoji-based format for the gem
      # @param json [Hash] the json hash, with symbolized keys.
      def display(json:)
        if json[:exists]
          puts gem_details(json: json)
        else
          puts not_found(gem_name: json[:name])
        end
      end

      # Outputs the number of gems being queried.
      # @param num [Numeric] the number of gems.
      def gem_count(num)
        puts "=> Gems: #{num}"
      end

      # Outputs the current batch and total number of batches
      # @param num [Numeric] the current batch number.
      # @param total [Numeric] the total number of batches.
      def batch_iterator(num, total)
        puts "=> Batch: #{num} of #{total}".magenta
      end

      # Outputs the list of gems being looked up from the batch.
      # @param batch [Array] the array of gems.
      def querying(batch)
        puts "=> Looking up: #{batch.join(", ")}"
      end

      # Returns whether the serializer is meant to be used to stream content.
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
          output.push "=> Gem: #{json[:name]} is at #{json[:version]}".green
          output.push "==> Updated:    #{convert_date(date: json[:version_created_at])}"
          output.push "==> Homepage:   #{json[:homepage_uri]}"
          output.push "==> Repository: #{json[:source_code_uri]}" if json[:source_code_uri]
          output.push changelog(changelog_uri: json[:changelog_uri])
          output.push mailing_list(mailing_list_uri: json[:mailing_list_uri])
        end.join "\n"
      end
      # rubocop:enable Metrics/AbcSize

      def changelog(changelog_uri:)
        if changelog_uri && !changelog_uri.empty?
          "==> Changelog:  #{changelog_uri}".light_blue
        else
          '==> Changelog:  No changelog'.red
        end
      end

      def mailing_list(mailing_list_uri:)
        if mailing_list_uri && !mailing_list_uri.empty?
          "==> List:       #{mailing_list_uri}".light_blue
        else
          '==> List:       No mailing list'.red
        end
      end

      # Generates the "gem not found" string
      # @param gem_name [String] the name of the gem that was not found.
      # @return [String] the gem not found string.
      def not_found(gem_name:)
        "=> Gem: #{gem_name} not found".red
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

module GemLookup
  module Serializers::Emoji
    class << self
      # Outputs the emoji-based format for the gem
      # @param json [Hash] the json hash, with symbolized keys.
      def display(json:)
        if json[:exists]
          puts gem_details(json: json)
        else
          puts not_found(gem_name: json[:name])
        end
      end

      # Outputs the number of gems being queried.
      # @param num [Numeric] the number of gems.
      def gem_count(num)
        puts "=> ✨ Gems: #{num}"
      end

      # Outputs the current batch and total number of batches
      # @param num [Numeric] the current batch number.
      # @param total [Numeric] the total number of batches.
      def batch_iterator(num, total)
        puts "=> 🧺 Batch: #{num} of #{total}".magenta
      end

      # Outputs the list of gems being looked up from the batch.
      # @param batch [Array] the array of gems.
      def querying(batch)
        puts "=> 🔎 Looking up: #{batch.join(", ")}"
      end

      # Returns whether the serializer is meant to be used to stream content.
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
          output.push "==> 🏠 #{json[:homepage_uri]}"
          output.push "==> 🔗 #{json[:source_code_uri]}" if json[:source_code_uri]
          output.push changelog(changelog_uri: json[:changelog_uri])
          output.push mailing_list(mailing_list_uri: json[:mailing_list_uri])
        end.join "\n"
      end
      # rubocop:enable Metrics/AbcSize

      def changelog(changelog_uri:)
        if changelog_uri && !changelog_uri.empty?
          "==> 📑 #{changelog_uri}".light_blue
        else
          '==> 📑 No changelog'.red
        end
      end

      def mailing_list(mailing_list_uri:)
        if mailing_list_uri && !mailing_list_uri.empty?
          "==> 💌 #{mailing_list_uri}".light_blue
        else
          '==> 💌 No mailing list'.red
        end
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
