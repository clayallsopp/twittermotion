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