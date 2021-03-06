# GemLookup :detective: ![workflow ci badge][ci badge]

Uses the [`typhoeus` :gem:][typhoeus] to make parallel requests to the public
[RubyGems API][rubygems api].

## Installation

```sh
$ gem install gem_lookup
```

### Design

The idea behind `gem_lookup` is that you'll call the it using the `gems` executable command. It
should be used when you are doing maintenance and project upgrades. It will be able to answer
questions the [RubyGems website][rubygems site] can.

```sh
gems
```

This will be made available when the gem is installed.

### Flags

#### Help

Pass `-h` or `--help` to get help.

```sh
$ gems --help
```

#### Version

Pass `-v` or `--version` to get the installed version.

```sh
$ gems --version
```

### Pass It Some Gems

Since it sends requests in parallel, the order you pass gems in may not be the order in which
you see the results. 

#### Formatting

The list of gems are lowercased, and then de-duped. So don't worry if you pass in any
capitalization or duplicate gems; It's got you covered. :sparkling_heart:

#### Output

By default, there will be many emojis to identify info, and a small variety of colors depending
on whether certain criteria are met for the line. It also looks even better with font ligatures
enabled, so if your font and/or terminal support them, it is recommended that they be enabled.

#### The Basics

##### Default Output

Just pass it a gem name.

```sh
$ gems pry
=> 🔎 Looking up: pry
=> 💎 pry is at 0.14.1
==> 📅 April 12, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/pry
==> 🏠 http://pry.github.io
==> 🔗 https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
```

##### Wordy Output

Use the `-w` or `--wordy` flags for emoji-less output.

```
$ gems --wordy pry
=> Looking up: pry
=> Gem: pry is at 0.14.1
==> Updated:      April 12, 2021
==> License:      MIT
==> Location:     https://rubygems.org/gems/pry
==> Homepage:     http://pry.github.io
==> Source Code:  https://github.com/pry/pry
==> Changelog:    https://github.com/pry/pry/blob/master/CHANGELOG.md
==> Mailing List: Unavailable
```

##### JSON Output

Use the `-j` or `--json` flags for JSON-based output. Two entries are added to each gem queried:
1. `exists` is whether or not the gem was found.
2. `timeout` is whether or not the request to the server for the gem timed out.

```
$ gems --json pry
{
  "gems": [
    {
      "name": "pry",
      "downloads": 212107466,
      "version": "0.14.1",
      "version_created_at": "2021-04-12T10:37:24.934Z",
      "version_downloads": 1719287,
      "platform": "ruby",
      "authors": "John Mair (banisterfiend), Conrad Irwin, Ryan Fitzgerald, Kyrylo Silin",
      "info": "Pry is a runtime developer console and IRB alternative with powerful\nintrospection capabilities. Pry aims to be more than an IRB replacement. It is\nan attempt to bring REPL driven programming to the Ruby language.\n",
      "licenses": [
        "MIT"
      ],
      "metadata": {
        "changelog_uri": "https://github.com/pry/pry/blob/master/CHANGELOG.md",
        "bug_tracker_uri": "https://github.com/pry/pry/issues",
        "source_code_uri": "https://github.com/pry/pry"
      },
      "yanked": false,
      "sha": "99b6df0665875dd5a39d85e0150aa5a12e2bb4fef401b6c4f64d32ee502f8454",
      "project_uri": "https://rubygems.org/gems/pry",
      "gem_uri": "https://rubygems.org/gemspry-0.14.1.gem",
      "homepage_uri": "http://pry.github.io",
      "wiki_uri": null,
      "documentation_uri": null,
      "mailing_list_uri": null,
      "source_code_uri": "https://github.com/pry/pry",
      "bug_tracker_uri": "https://github.com/pry/pry/issues",
      "changelog_uri": "https://github.com/pry/pry/blob/master/CHANGELOG.md",
      "funding_uri": null,
      "dependencies": {
        "development": [

        ],
        "runtime": [
          {
            "name": "coderay",
            "requirements": "~> 1.1"
          },
          {
            "name": "method_source",
            "requirements": "~> 1.0"
          }
        ]
      },
      "exists": true,
      "timeout": false
    }
  ]
}
```

#### Standard Mode

Since there is a [rate limit](#rate-limit), passing less gems than that will cause it to run in
`Standard` mode:

```sh
$ gems pry rspec sentry-ruby rails
=> 🤔 4 gems
=> 🔎 pry, rspec, sentry-ruby, rails
=> 💎 pry is at 0.14.1
==> 📅 April 12, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/pry
==> 🏠 http://pry.github.io
==> 🔗 https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 rspec is at 3.10.0
==> 📅 October 30, 2020
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rspec
==> 🏠 http://github.com/rspec
==> 🔗 https://github.com/rspec/rspec
==> 📑 Unavailable
==> 💌 https://groups.google.com/forum/#!forum/rspec
=> 💎 sentry-ruby is at 4.6.1
==> 📅 July 8, 2021
==> 💼 Apache-2.0
==> 🧭 https://rubygems.org/gems/sentry-ruby
==> 🏠 https://github.com/getsentry/sentry-ruby
==> 🔗 https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 rails is at 6.1.4
==> 📅 June 24, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rails
==> 🏠 https://rubyonrails.org
==> 🔗 https://github.com/rails/rails/tree/v6.1.4
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.4
==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk
```

#### Batch Mode

When more gems are passed in than the [rate limit](#rate-limit) supports, the script will enter
`Batch` mode. In this mode, the output is slightly different, and there is a **one second** pause
between batches, so as to respect the rate limit.

```sh
$ gems byebug pinglish rspec rubocop rubocop-rspec rubocop-rails sentry-ruby sentry-rails pry byebug typhoeus faraday Faraday rails pagy clowne discard aasm logidze GLOBALIZE lockbox factory_BOT faker site_prism nokogiri simplecov
=> 🤔 24 gems
=> 🧺 1 of 3
=> 🔎 byebug, pinglish, rspec, rubocop, rubocop-rspec, rubocop-rails, sentry-ruby, sentry-rails, pry, typhoeus
=> 💎 rspec is at 3.10.0
==> 📅 October 30, 2020
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rspec
==> 🏠 http://github.com/rspec
==> 🔗 https://github.com/rspec/rspec
==> 📑 Unavailable
==> 💌 https://groups.google.com/forum/#!forum/rspec
=> 💎 rubocop-rspec is at 2.4.0
==> 📅 June 9, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rubocop-rspec
==> 🏠 https://github.com/rubocop/rubocop-rspec
==> 🔗 Unavailable
==> 📑 https://github.com/rubocop/rubocop-rspec/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 rubocop is at 1.18.3
==> 📅 July 6, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rubocop
==> 🏠 https://rubocop.org/
==> 🔗 https://github.com/rubocop/rubocop/
==> 📑 https://github.com/rubocop/rubocop/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 sentry-rails is at 4.6.1
==> 📅 July 8, 2021
==> 💼 Apache-2.0
==> 🧭 https://rubygems.org/gems/sentry-rails
==> 🏠 https://github.com/getsentry/sentry-ruby
==> 🔗 https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 byebug is at 11.1.3
==> 📅 April 23, 2020
==> 💼 BSD-2-Clause
==> 🧭 https://rubygems.org/gems/byebug
==> 🏠 https://github.com/deivid-rodriguez/byebug
==> 🔗 https://github.com/deivid-rodriguez/byebug
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 pinglish is at 0.2.1
==> 📅 November 13, 2014
==> 💼 None
==> 🧭 https://rubygems.org/gems/pinglish
==> 🏠 https://github.com/jbarnette/pinglish
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 sentry-ruby is at 4.6.1
==> 📅 July 8, 2021
==> 💼 Apache-2.0
==> 🧭 https://rubygems.org/gems/sentry-ruby
==> 🏠 https://github.com/getsentry/sentry-ruby
==> 🔗 https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 rubocop-rails is at 2.11.3
==> 📅 July 11, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rubocop-rails
==> 🏠 https://docs.rubocop.org/rubocop-rails/
==> 🔗 https://github.com/rubocop/rubocop-rails/
==> 📑 https://github.com/rubocop/rubocop-rails/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 pry is at 0.14.1
==> 📅 April 12, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/pry
==> 🏠 http://pry.github.io
==> 🔗 https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 typhoeus is at 1.4.0
==> 📅 May 8, 2020
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/typhoeus
==> 🏠 https://github.com/typhoeus/typhoeus
==> 🔗 https://github.com/typhoeus/typhoeus
==> 📑 Unavailable
==> 💌 http://groups.google.com/group/typhoeus
=> 🧺 2 of 3
=> 🔎 faraday, rails, pagy, clowne, discard, aasm, logidze, globalize, lockbox, factory_bot
=> 💎 discard is at 1.2.0
==> 📅 February 17, 2020
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/discard
==> 🏠 https://github.com/jhawthorn/discard
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 rails is at 6.1.4
==> 📅 June 24, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rails
==> 🏠 https://rubyonrails.org
==> 🔗 https://github.com/rails/rails/tree/v6.1.4
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.4
==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk
=> 💎 pagy is at 4.10.1
==> 📅 June 24, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/pagy
==> 🏠 https://github.com/ddnexus/pagy
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 clowne is at 1.3.0
==> 📅 May 12, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/clowne
==> 🏠 https://clowne.evilmartians.io/
==> 🔗 http://github.com/clowne-rb/clowne
==> 📑 https://github.com/clowne-rb/clowne/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 logidze is at 1.2.0
==> 📅 June 11, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/logidze
==> 🏠 http://github.com/palkan/logidze
==> 🔗 http://github.com/palkan/logidze
==> 📑 https://github.com/palkan/logidze/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 aasm is at 5.2.0
==> 📅 May 1, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/aasm
==> 🏠 https://github.com/aasm/aasm
==> 🔗 https://github.com/aasm/aasm
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 lockbox is at 0.6.5
==> 📅 July 7, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/lockbox
==> 🏠 https://github.com/ankane/lockbox
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 factory_bot is at 6.2.0
==> 📅 May 7, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/factory_bot
==> 🏠 https://github.com/thoughtbot/factory_bot
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 globalize is at 6.0.1
==> 📅 June 23, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/globalize
==> 🏠 http://github.com/globalize/globalize
==> 🔗 Unavailable
==> 📑 Unavailable
==> 💌 Unavailable
=> 💎 faraday is at 1.5.1
==> 📅 July 11, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/faraday
==> 🏠 https://lostisland.github.io/faraday
==> 🔗 https://github.com/lostisland/faraday
==> 📑 https://github.com/lostisland/faraday/releases/tag/v1.5.1
==> 💌 Unavailable
=> 🧺 3 of 3
=> 🔎 faker, site_prism, nokogiri, simplecov
=> 💎 site_prism is at 3.7.1
==> 📅 February 19, 2021
==> 💼 BSD-3-Clause
==> 🧭 https://rubygems.org/gems/site_prism
==> 🏠 https://github.com/site-prism/site_prism
==> 🔗 https://github.com/site-prism/site_prism
==> 📑 https://github.com/site-prism/site_prism/blob/main/CHANGELOG.md
==> 💌 Unavailable
=> 💎 simplecov is at 0.21.2
==> 📅 January 9, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/simplecov
==> 🏠 https://github.com/simplecov-ruby/simplecov
==> 🔗 https://github.com/simplecov-ruby/simplecov/tree/v0.21.2
==> 📑 https://github.com/simplecov-ruby/simplecov/blob/main/CHANGELOG.md
==> 💌 https://groups.google.com/forum/#!forum/simplecov
=> 💎 faker is at 2.18.0
==> 📅 May 15, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/faker
==> 🏠 https://github.com/faker-ruby/faker
==> 🔗 https://github.com/faker-ruby/faker
==> 📑 https://github.com/faker-ruby/faker/blob/master/CHANGELOG.md
==> 💌 Unavailable
=> 💎 nokogiri is at 1.11.7
==> 📅 June 3, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/nokogiri
==> 🏠 https://nokogiri.org
==> 🔗 https://github.com/sparklemotion/nokogiri
==> 📑 https://nokogiri.org/CHANGELOG.html
==> 💌 Unavailable
```

#### Non-Existent Gems

If a gem isn't found, the output will be a little bit different: that particular line will be
red. It's also important to know that not finding a gem doesn't block other gems from being looked
up.

```sh
$ gems non-existent rails
=> 🤔 2 gems
=> 🔎 non-existent, rails
=> 💎 non-existent not found
=> 💎 rails is at 6.1.4
==> 📅 June 24, 2021
==> 💼 MIT
==> 🧭 https://rubygems.org/gems/rails
==> 🏠 https://rubyonrails.org
==> 🔗 https://github.com/rails/rails/tree/v6.1.4
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.4
==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk
```

#### Timing Out

If a gem lookup times out, the output will let you know.

```sh
$ gems rails
=> 🔎 Looking up: rails
=> 💎 rails lookup timed out
```

## Rate Limit

Please be aware there is a [rate limit][rate limit] to be mindful of.

As of June 10th, 2021: `API and website: 10 requests per second`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and the created tag, and push the 
`gem_lookup.gem_spec` file to [rubygems.org][rubygems site].

## Contributing

Bug reports and pull requests are welcome [on GitHub][git] This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct][coc].

## License

The gem is available as open source under the terms of the [MIT License][mit].

## Code of Conduct

Everyone interacting in the GemLookup project's codebases, issue trackers, chat rooms and
mailing lists is expected to follow the [code of conduct][coc].

[ci badge]: https://github.com/trueheart78/gem_lookup/actions/workflows/tests.yml/badge.svg
[typhoeus]: https://github.com/typhoeus/typhoeus/
[rubygems site]: https://rubygems.org/
[rubygems api]: https://guides.rubygems.org/rubygems-org-api/#gem-methods
[rate limit]: https://guides.rubygems.org/rubygems-org-rate-limits/
[git]: https://github.com/trueheart78/gem_lookup/
[coc]: https://github.com/trueheart78/gem_lookup/blob/master/CODE_OF_CONDUCT.md
[mit]: https://opensource.org/licenses/MIT
