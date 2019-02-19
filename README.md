# Todoable

 This gem wraps the endpoints of its HTTP API providing methods to create, update and delete lists. Each list contains an association called `items` that can be created, deleted and marked finished.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage

TODO: Write usage instructions here
To interact with client, your creditnals need to be set first in an `env` file that you need to create with the following keys
`TODOABLE_USERNAME` and `TODOABLE_PASSWORD`

The `Client` class contains methods that interact with `HTTParty` to make the HTTP requests and authentication.  The two main classes to interact with API Endpoints are the `List` and `Item` that build off the client class for network requests


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

