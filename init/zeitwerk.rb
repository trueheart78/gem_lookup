# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.new

root_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

loader.push_dir(File.join(root_dir, 'lib'))

if ENV['APP_ENV'] != 'production'
  loader.push_dir(File.join(root_dir, 'spec'))
  loader.ignore(File.join(root_dir, '**', '*_spec.rb'))
end

loader.setup
