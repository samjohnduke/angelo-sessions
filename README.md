# Angelo::Sessions

Angelo Sessions is a first attempt at adding external components to the Angelo framework. 


## Installation

Add this line to your application's Gemfile:

    gem 'angelo-sessions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install angelo-sessions

## Usage

### Step One

Include sessions in your app

```ruby 
  class App < Angelo::Base
    include Angelo::Sessions

    ...
  
  end
```
### Step Two

configure sessions using the session_config method

```ruby
session_config :secret_token => 'WB8hc93bz6MIsy2HdW5xA4vJ446Ww1ib'
```


### Step Three

Add the initialize and finalize methods to your before and after blocks like so

```ruby 
  before do
    init_session request
  end

  after do
    finalize_session
  end
```

### Step Four

access and set values into the session through out your application

```ruby 
  session[:some_key] = :some_value

  some_value = session[:some_key]
```

### Step Five

(this is too many steps :(. Needs some work )

## TODO

[ ] Actually run code for the first time. (It's all hypothetical at the moment ie. never been run)
[ ] Test
[ ] Implement Cookie store

Open to Suggestions

## Contributing

1. Fork it ( https://github.com/samjohnduke/angelo-sessions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
