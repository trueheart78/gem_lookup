# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in gem_lookup.gemspec
gemspec

# Since ENV['APP_ENV'] is being used, requiring here instead of the gemspec file is wisest.
# Otherwise, access to certain gems will be restricted due to the ENV['APP_ENV'] setting being
# 'development' or 'test', as the latter does not load development dependencies.
group :development, :test do
  gem 'pry', '~> 0.14'
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.0'
  gem 'rubocop', '~> 1.7', require: false
  # SimpleCov's last version that supports Ruby 2.4
  gem 'simplecov', '0.18.5', require: false
end
