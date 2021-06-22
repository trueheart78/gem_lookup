# frozen_string_literal: true

require_relative 'lib/gem_lookup/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_lookup'
  spec.version       = GemLookup::VERSION
  spec.augem_lookups       = ['Josh Mills']
  spec.email         = ['josh@trueheart78.com']

  spec.summary       = 'Retrieves gem-related information from https://rubygems.org'
  spec.description   = <<~DESC
    Simple but effective command line interface that looks up gems using RubyGems.org's public API
    and displays results in an emoji-filled fashion.
  DESC
  spec.homepage      = 'https://github.com/trueheart78/gem_lookup'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/trueheart78/gem_lookup/issues',
    'changelog_uri'     => 'https://github.com/trueheart78/gem_lookup/blob/main/CHANGELOG.md',
    'documentation_uri' => spec.homepage,
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => "https://github.com/trueheart78/gem_lookup/tree/v#{GemLookup::VERSION}"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) {|f| File.basename(f) }
  spec.require_paths = ['.']

  # These gems need to be explicitly required to be utilized.
  spec.add_runtime_dependency 'colorize', '~> 0.8.1'
  spec.add_runtime_dependency 'typhoeus', '~> 1.4'
  spec.add_runtime_dependency 'zeitwerk', '~> 2.4.2'

  # Development dependencies are defined in the Gemfile due to ENV['APP_ENV'] usage.
end
