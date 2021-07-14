# frozen_string_literal: true

require_relative '../booster_pack'

# Requiring satisfies Zeitwerk's need for GemLookup to be defined in this file.
# It also solves a GemLookup::Help.version constant check, as this had yet to be loaded.
require_relative 'gem_lookup/version'
