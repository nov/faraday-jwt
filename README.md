# Faraday::JWT

Faraday Middleware for JWT Request & Response

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add faraday-jwt

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install faraday-jwt

## Usage

### Request

```ruby
conn = Faraday.new(...) do |f|
  f.request :jwt
  ...
end

conn.post('/', { foo: :bar })
# POST with
# Content-Type: application/jwt
# Body: eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJmb28iOiJiYXIifQ.
```

or optionally signing

```ruby
conn = Faraday.new(...) do |f|
  f.request :jwt, signing_key: private_key
  ...
end
```

### Response

```ruby
conn = Faraday.new(...) do |f|
  f.response :jwt
  ...
end

res = conn.get('jwt')
res.body
# => JSON::JWT instance
```

or optionally verifying

```ruby
conn = Faraday.new(...) do |f|
  f.response :jwt, verification_key: public_key
  ...
end
```

Even with the first seting, `response.body` would be `JSON::JWS` instance, so you can verify it by yourself.
You can also get the raw input via `response.env[:raw_body]`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nov/faraday-jwt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nov/faraday-jwt/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Faraday::JWT project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nov/faraday-jwt/blob/master/CODE_OF_CONDUCT.md).
