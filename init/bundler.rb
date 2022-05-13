# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['APP_ENV'].to_sym) unless ENV.fetch('APP_ENV', nil) == 'production'
