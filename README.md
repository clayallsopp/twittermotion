# TwitterMotion, a RubyMotion Wrapper

## Usage

Sign in:

```ruby
Twitter.sign_in do |granted, ns_error|
  # have fun
end
```

See accounts:

```ruby
> Twitter.accounts
=> [#<Twitter::User>]
> Twitter.accounts[0].username
=> "clayallsopp"
```

Compose a tweet:

```ruby
Twitter.accounts[0].compose(tweet: 'Hello RubyMotion!',
  images: [ui_image], urls: ["http://clayallsopp.com"]) do |composer|
  if composer.error
    # check error.invalid_tweet/images/urls
  elsif composer.cancelled?
    # user didnt sent the tweet
  elsif composer.done?
    # user sent the tweet
  end
end
```

or without a user:

```ruby
composer = Twitter::Composer.new
composer.compose(tweet: 'Hello RubyMotion!',
  images: [ui_image], urls: ["http://clayallsopp.com"]) do |composer|
  ...
end
```

Grab a user's timeline:

```ruby
user.get_timeline do |hash, ns_error|
  p "Timeline #{hash}"
  # => [{\"coordinates\"=>nil, \"truncated\"=>false.....}, ....]
end
```

## Installation

1. `gem install twittermotion`

2. Add `require 'twittermotion'` to your `Rakefile`

## Pull Requests

It would be really cool if this was a fully-compatible Twitter API wrapper, so add whatever functionality you think helps!