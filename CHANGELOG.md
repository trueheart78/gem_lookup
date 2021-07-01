# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][changelog], and this project adheres to 
[Semantic Versioning][semver].

## [0.8.0] - Unreleased

### Added

* CI support for multiple Ruby versions:
  * MRI Ruby 2.4
  * MRI Ruby 2.5
  * MRI Ruby 2.6
  * MRI Ruby 2.7
  * MRI Ruby 3.0
  * MRY Ruby head
* [Zeitwerk][zeitwerk] autoloader gem.
* Support for the `ENV['APP_ENV']` variable.
  * Defaults to `development`.
  * `exe/gems` explicitly sets it to `production`.
  * `spec/spec_helper.rb` explicitly sets it to `test`.
* New **Wordy** output mode.
  * No emojis, only words. :frowning_face:
  * Enabled by passing `--wordy` or `-w` to the executable.
* Support for request timeouts.
  * JSON responses now have an extra `"timeout"` boolean key.
* Requests now have an `"Accept Encoding" => "gzip"` header.
* Requests now limit timeouts to 10 seconds.

### Changed

* Converted to a real gem! :gem:
  * `gem install gem_lookup`
* Includes an executable, `gems`.
  * Any previous symlinked `gems` script should be deleted.
* Renamed repository from `gem-lookup` to `gem_lookup`.

### Removed

* Dropped support for Ruby 2.3 and earlier.

## [0.7.0] - 2021-06-18

### Added

* New `--json` / `-j` flags return a JSON data structure that includes the entire response from
  [RubyGems.org][gems api].
  * Gems that are found successfully have an `"exists" : true` added to their JSON.
  * Gems that are not found have a simple structure: `{ "name" : "gem_name", "exists" : false }`

## [0.6.5] - 2021-06-17

### Changed

* Flags are now analyzed at `#lookup` time.

## [0.6.4] - 2021-06-15

### Changed

* Unsupported flags now return an error instead of causing a lookup.

## [0.6.3] - 2021-06-14

### Changed

* Refactored the class-based methods to be more concise.
* The `--help` format has been updated to be akin to [`the_silver_searcher`'s][ag].
* Calling the application without any arguments now displays the `--help` content.

## [0.6.2] - 2021-06-14

### Changed

* Standardized the changelog emoji, so it is the same if there is a changelog or not.

## [0.6.1] - 2021-06-14

### Changed

* Extracted the `RubyGems.usage` method and added it to the message when the file is called without
  any arguments.

### Added

## [0.6.0] - 2021-06-14

### Added

* Basic version support.

[changelog]: https://keepachangelog.com/en/1.0.0/
[semver]: https://semver.org/spec/v2.0.0.html
[ag]: https://github.com/ggreer/the_silver_searcher
[gems api]: https://guides.rubygems.org/rubygems-org-api/#gem-methods
[zeitwerk]: https://github.com/fxn/zeitwerk
