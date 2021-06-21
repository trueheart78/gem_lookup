# frozen_string_literal: true

require_relative 'lib/gem/lookup/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem-lookup'
  spec.version       = Gem::Lookup::VERSION
  spec.authors       = ['Josh Mills']
  spec.email         = ['josh@trueheart78.com']

  spec.summary       = 'Retrieves gem-related information from https://rubygems.org'
  spec.description   = <<~DESC
    Simple but effective command line interface that looks up gems using RubyGems.org's public API
    and displays results in an emoji-filled fashion.
  DESC
  spec.homepage      = 'https://github.com/trueheart78/gem-lookup'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/trueheart78/gem-lookup'
  spec.metadata['changelog_uri'] = 'https://github.com/trueheart78/gem-lookup/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'typhoeus', '~> 1.4'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'simplecov', '~> 0.21'
end
