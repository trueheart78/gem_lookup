# Gem Lookup :detective:

Uses inline Bundler and the [`typhoeus` :gem:][typhoeus] to make parallel requests to the public RubyGems API.

## Usage

### Make It Executable

First, make sure the `gems.rb` file is executable.

```sh
chmod +ux gems.rb
```

### Design

The idea behind `gems.rb` is that you'll symlink it into a directory in your `$PATH`, and call
it when you are doing maintenance and project upgrades. It should be able to answer questions
the [RubyGems website][rubygems site] can.

```sh
ln -s /path/to/gems.rb ~/bin/gems
```

Then it can be used instead anywhere by calling `gems` instead of having to directly
reference `gems.rb`.

### Help

Pass `-h` or `--help` to get help.

```sh
$ ./gems.rb --help            
```

### Pass It Some Gems

Since it sends requests in parallel, the order you pass gems in may not be the order in which
you see the results. 

#### Formatting

The list of gems are lowercased, and then de-duped. So don't worry if you pass in any
capitalization or duplicate gems; It's got you covered. :sparkling_heart:

#### Output

You're going to get lots of emojis to identify info, and a small variety of colors depending
on whether certain criteria are met for the line.

#### Standard Mode

Since there is a [rate limit](#rate-limit), passing less gems than that will cause it to run in
`Standard` mode:

```sh
$ ./gems.rb pry rspec sentry-ruby rails
=> #️⃣ Gems: 4
=> ⚙️ Mode: Standard
=> 🕵️ Looking up: pry, rspec, sentry-ruby, rails
=> 💎 sentry-ruby
==> ➡️ 4.5.1
==> 📅 June 4, 2021
==> 🏠 https://github.com/getsentry/sentry-ruby
==> ℹ️ https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
=> 💎 rails
==> ➡️ 6.1.3.2
==> 📅 May 5, 2021
==> 🏠 https://rubyonrails.org
==> ℹ️ https://github.com/rails/rails/tree/v6.1.3.2
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2
=> 💎 rspec
==> ➡️ 3.10.0
==> 📅 October 30, 2020
==> 🏠 http://github.com/rspec
==> ℹ️ https://github.com/rspec/rspec
==> 🚫 No changelog
=> 💎 pry
==> ➡️ 0.14.1
==> 📅 April 12, 2021
==> 🏠 http://pry.github.io
==> ℹ️ https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
```

#### Batch Mode

When more gems are passed in than the [rate limit](#rate-limit) supports, the script will enter
`Batch` mode. In this mode, the output is slightly different, and there is a **one second** pause
between batches, so as to respect the rate limit.

```sh
$ ./gems.rb byebug pinglish rspec rubocop rubocop-rspec rubocop-rails sentry-ruby sentry-rails pry byebug typhoeus faraday Faraday rails pagy clowne discard aasm logidze GLOBALIZE lockbox factory_BOT faker site_prism nokogiri simplecov
=> #️⃣ Gems: 24
=> ⚙️ Mode: Batch
=> 🧺 Batch: 1 of 3
=> 🕵️ Looking up: byebug, pinglish, rspec, rubocop, rubocop-rspec, rubocop-rails, sentry-ruby, sentry-rails, pry, typhoeus
=> 💎 pinglish
==> ➡️ 0.2.1
==> 📅 November 13, 2014
==> 🏠 https://github.com/jbarnette/pinglish
==> 🚫 No changelog
=> 💎 byebug
==> ➡️ 11.1.3
==> 📅 April 23, 2020
==> 🏠 https://github.com/deivid-rodriguez/byebug
==> ℹ️ https://github.com/deivid-rodriguez/byebug
==> 🚫 No changelog
=> 💎 rspec
==> ➡️ 3.10.0
==> 📅 October 30, 2020
==> 🏠 http://github.com/rspec
==> ℹ️ https://github.com/rspec/rspec
==> 🚫 No changelog
=> 💎 rubocop
==> ➡️ 1.16.1
==> 📅 June 9, 2021
==> 🏠 https://rubocop.org/
==> ℹ️ https://github.com/rubocop/rubocop/
==> 📑 https://github.com/rubocop/rubocop/blob/master/CHANGELOG.md
=> 💎 sentry-ruby
==> ➡️ 4.5.1
==> 📅 June 4, 2021
==> 🏠 https://github.com/getsentry/sentry-ruby
==> ℹ️ https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
=> 💎 rubocop-rails
==> ➡️ 2.10.1
==> 📅 May 5, 2021
==> 🏠 https://docs.rubocop.org/rubocop-rails/
==> ℹ️ https://github.com/rubocop/rubocop-rails/
==> 📑 https://github.com/rubocop/rubocop-rails/blob/master/CHANGELOG.md
=> 💎 rubocop-rspec
==> ➡️ 2.4.0
==> 📅 June 9, 2021
==> 🏠 https://github.com/rubocop/rubocop-rspec
==> 📑 https://github.com/rubocop/rubocop-rspec/blob/master/CHANGELOG.md
=> 💎 pry
==> ➡️ 0.14.1
==> 📅 April 12, 2021
==> 🏠 http://pry.github.io
==> ℹ️ https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
=> 💎 typhoeus
==> ➡️ 1.4.0
==> 📅 May 8, 2020
==> 🏠 https://github.com/typhoeus/typhoeus
==> ℹ️ https://github.com/typhoeus/typhoeus
==> 🚫 No changelog
=> 💎 sentry-rails
==> ➡️ 4.5.1
==> 📅 June 4, 2021
==> 🏠 https://github.com/getsentry/sentry-ruby
==> ℹ️ https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
=> 🧺 Batch: 2 of 3
=> 🕵️ Looking up: faraday, rails, pagy, clowne, discard, aasm, logidze, globalize, lockbox, factory_bot
=> 💎 faraday
==> ➡️ 1.4.2
==> 📅 May 22, 2021
==> 🏠 https://lostisland.github.io/faraday
==> ℹ️ https://github.com/lostisland/faraday
==> 📑 https://github.com/lostisland/faraday/releases/tag/v1.4.2
=> 💎 logidze
==> ➡️ 1.2.0
==> 📅 June 11, 2021
==> 🏠 http://github.com/palkan/logidze
==> ℹ️ http://github.com/palkan/logidze
==> 📑 https://github.com/palkan/logidze/blob/master/CHANGELOG.md
=> 💎 rails
==> ➡️ 6.1.3.2
==> 📅 May 5, 2021
==> 🏠 https://rubyonrails.org
==> ℹ️ https://github.com/rails/rails/tree/v6.1.3.2
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2
=> 💎 aasm
==> ➡️ 5.2.0
==> 📅 May 1, 2021
==> 🏠 https://github.com/aasm/aasm
==> ℹ️ https://github.com/aasm/aasm
==> 🚫 No changelog
=> 💎 discard
==> ➡️ 1.2.0
==> 📅 February 17, 2020
==> 🏠 https://github.com/jhawthorn/discard
==> 🚫 No changelog
=> 💎 factory_bot
==> ➡️ 6.2.0
==> 📅 May 7, 2021
==> 🏠 https://github.com/thoughtbot/factory_bot
==> 🚫 No changelog
=> 💎 lockbox
==> ➡️ 0.6.4
==> 📅 April 6, 2021
==> 🏠 https://github.com/ankane/lockbox
==> 🚫 No changelog
=> 💎 pagy
==> ➡️ 4.8.0
==> 📅 June 8, 2021
==> 🏠 https://github.com/ddnexus/pagy
==> 🚫 No changelog
=> 💎 clowne
==> ➡️ 1.3.0
==> 📅 May 12, 2021
==> 🏠 https://clowne.evilmartians.io/
==> ℹ️ http://github.com/clowne-rb/clowne
==> 📑 https://github.com/clowne-rb/clowne/blob/master/CHANGELOG.md
=> 💎 globalize
==> ➡️ 6.0.0
==> 📅 January 11, 2021
==> 🏠 http://github.com/globalize/globalize
==> 🚫 No changelog
=> 🧺 Batch: 3 of 3
=> 🕵️ Looking up: faker, site_prism, nokogiri, simplecov
=> 💎 site_prism
==> ➡️ 3.7.1
==> 📅 February 19, 2021
==> 🏠 https://github.com/site-prism/site_prism
==> ℹ️ https://github.com/site-prism/site_prism
==> 📑 https://github.com/site-prism/site_prism/blob/main/CHANGELOG.md
=> 💎 faker
==> ➡️ 2.18.0
==> 📅 May 15, 2021
==> 🏠 https://github.com/faker-ruby/faker
==> ℹ️ https://github.com/faker-ruby/faker
==> 📑 https://github.com/faker-ruby/faker/blob/master/CHANGELOG.md
=> 💎 simplecov
==> ➡️ 0.21.2
==> 📅 January 9, 2021
==> 🏠 https://github.com/simplecov-ruby/simplecov
==> ℹ️ https://github.com/simplecov-ruby/simplecov/tree/v0.21.2
==> 📑 https://github.com/simplecov-ruby/simplecov/blob/main/CHANGELOG.md
=> 💎 nokogiri
==> ➡️ 1.11.7
==> 📅 June 3, 2021
==> 🏠 https://nokogiri.org
==> ℹ️ https://github.com/sparklemotion/nokogiri
==> 📑 https://nokogiri.org/CHANGELOG.html
```

#### Non-Existent Gems

If a gem isn't found, the output will be a little bit different: that particular line will be
red. It's also important to know that not finding a gem doesn't block other gems from being looked
up.

```sh
$ ./gems.rb non-existent rails
=> #️⃣ Gems: 2
=> ⚙️ Mode: Standard
=> 🕵️ Looking up: non-existent, rails
=> 💎 non-existent not found
=> 💎 rails
==> ➡️ 6.1.3.2
==> 📅 May 5, 2021
==> 🏠 https://rubyonrails.org
==> ℹ️ https://github.com/rails/rails/tree/v6.1.3.2
==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2
```

## Rate Limit

Please be aware there is a [rate limit][rate limit] to be mindful of.

As of June 10th, 2021: `API and website: 10 requests per second`.

[typhoeus]: https://github.com/typhoeus/typhoeus/
[rubygems site]: https://rubygems.org/
[rate limit]: https://guides.rubygems.org/rubygems-org-rate-limits/
