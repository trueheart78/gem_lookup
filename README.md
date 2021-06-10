# Gem Lookup :detective:

Uses inline Bundler and the [`typhoeus` :gem:][typhoeus] to make parallel requests to the public RubyGems API.

## Usage

### Make It Executable

First, make sure the `gems.rb` file is executable.

```sh
chmod +ux gems.rb
```

### Pass It Some Gems

Since it sends requests in parallel, the order you pass gems in may not be the order in which
you see the results. 

```sh
$ ./gems.rb pry rspec sentry-ruby
=> 🕵️ Looking up: pry, rspec, sentry-ruby
=> 💎 sentry-ruby is at 4.5.1
==> 📅 June 4, 2021
==> 🏠 https://github.com/getsentry/sentry-ruby
==> ℹ️ https://github.com/getsentry/sentry-ruby
==> 📑 https://github.com/getsentry/sentry-ruby/blob/master/CHANGELOG.md
=> 💎 rspec is at 3.10.0
==> 📅 October 30, 2020
==> 🏠 http://github.com/rspec
==> ℹ️ https://github.com/rspec/rspec
==> 🚫 No changelog
=> 💎 pry is at 0.14.1
==> 📅 April 12, 2021
==> 🏠 http://pry.github.io
==> ℹ️ https://github.com/pry/pry
==> 📑 https://github.com/pry/pry/blob/master/CHANGELOG.md
```

### Passing In More Than 10 Gems

Due to rate limits (see below), it only handles 10 gems at a time. If you pass more than 10 gems
in, it just takes the first 10 and ignores the rest. In those cases, you'll see the following:

```sh
=> ⚠️ Limited to the first 10 gems due to rate limiting
```

## Rate Limit

Please be aware there is a [rate limit][rate limit] to be mindful of.

As of June 10th, 2021: `API and website: 10 requests per second`.

[typhoeus]: https://github.com/typhoeus/typhoeus/
[rate limit]: https://guides.rubygems.org/rubygems-org-rate-limits/
