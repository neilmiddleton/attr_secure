# attr_secure

Securely stores ActiveRecord attributes for a given model/attribute and a predefined secret.

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

To make an model attribute secure, first create a key:

    dd if=/dev/urandom bs=32 count=1 2>/dev/null | openssl base64

and add it to your environment as `ATTR_SECURE_SECRET`.
Then mark an attribute as secure:

    attr_secure :my_attribute

and read and write as normal (see above example)

Note: You will want to set your table columns for encrypted values to :text or
similar.  Encrypted values are long.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
