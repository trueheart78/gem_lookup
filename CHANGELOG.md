# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0] - Unreleased

### Changed

* Converted to a real gem! :gem:
  * `gem install gem-lookup`
* Includes an executable, `gems`.
  * You should delete any previous symlinked `gems` script.

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

[ag]: https://github.com/ggreer/the_silver_searcher
[gems api]: https://guides.rubygems.org/rubygems-org-api/#gem-methods
