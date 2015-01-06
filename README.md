Knp
===

The Kill Bill Notifications Proxy is a Rails mountable engine that can be exposed on a public IP to process notifications from gateways.


Mounting Knp into your own Rails app
------------------------------------

* Add `knp` to your Gemfile
* Add `mount Knp::Engine, at: "/killbill"` in your `config/routes.rb`


Configuration
-------------

Specify your Kill Bill server configuration in ```config/initializers/killbill_client.rb```:

```
KillBillClient.url        = 'http://127.0.0.1:8080/'
KillBillClient.api_key    = 'bob'
KillBillClient.api_secret = 'lazar'
KillBillClient.username   = 'admin'
KillBillClient.password   = 'password'
# To log requests
KillBillClient.logger     = Rails.logger
```


Running tests
-------------

```
rake test
```

Note: functional tests require an instance of Kill Bill to test against.
