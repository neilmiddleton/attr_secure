# attr_secure

[![Build Status](https://travis-ci.org/neilmiddleton/attr_secure.png?branch=master)](https://travis-ci.org/neilmiddleton/attr_secure)

Securely stores attribute values for your Ruby objects.  Also supports Active
Record and Sequel!

```
ENV["ATTR_SECURE_SECRET"] = "MySuperSecretKeyThatCannotBeGuessed"

class Report < ActiveRecord::Base
  attr_secure :secret_value
end

r = Report.new
r.secret_value = "ThisIsATest"
r.save
=> #<Report id: 116, secret_value: "EKq88AMFeRLqEx5knUcoJ4LOnrv52d7hfAFgEKMoDKzqNei4m7k...">

r = Report.find(116)
r.secret_value
=> "ThisIsATest"
```

## Installation

Add this line to your application's Gemfile:

    gem 'attr_secure'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_secure

## Usage

To make an model attribute secure, first you need a secure key:

    dd if=/dev/urandom bs=32 count=1 2>/dev/null | openssl base64

There's a number of ways of setting a key for a given attribute.  The easiest is to default the key via the environment.  
Setting the environment variable `ATTR_SECURE_SECRET` to a secret value will secure all attributes with the same key.

Alternatively, if you want to use different keys for different attributes you can do this too:

    attr_secure :my_attribute, :secret => "EKq88AMFeRLqEx5knUcoJ4LOnrv52d7hfAFgEKMoDKzqNei4m7kbu"
    
If you would like your key dependent on something else, a lambda is OK too:

    attr_secure :my_attribute, :secret => lambda {|record| record.user.secret }
    
Remember kids, it's not a good idea to hard-code secrets.

Note: You will want to set your table columns for encrypted values to :text or
similar.  Encrypted values are long.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
