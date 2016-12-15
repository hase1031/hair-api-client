# hair-api-client

[![Build Status](https://travis-ci.org/hase1031/hair-api-client.svg?branch=master)](https://travis-ci.org/hase1031/hair-api-client)

```hair-api-client``` is a generic Ruby wrapper to access HAIR API.
 
HAIR is Japanese web service.  
see:[https://hair.cm](https://hair.cm)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hair-api-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hair-api-client

## Usage

```ruby
require 'hair/api/client'
 
Hair::Api::Client.configure do |options|
  options[:token] = '[your api token]'
end
 
res = Hair::Api::Client.image_search('ponytail', {sort: 'asc'})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hair-api-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

