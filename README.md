Knp
===

The Kill Bill Notifications Proxy is a Rails mountable engine that can be exposed on a public IP to process notifications from gateways.

Assuming your Knp public address is killbill-public.acme.com, configure the notification URL in the gateway to be killbill-public.acme.com/notifications/_plugin-name_:

* https://killbill-public.acme.com/notifications/killbill-adyen
* https://killbill-public.acme.com/notifications/killbill-bitpay

If you have multiple Kill Bill clusters, you can specify an optional cluster parameter in the path (see also the configuration section):

* https://killbill-public.acme.com/notifications/killbill-adyen/europe
* https://killbill-public.acme.com/notifications/killbill-adyen/us
* https://killbill-public.acme.com/notifications/killbill-bitpay/europe
* https://killbill-public.acme.com/notifications/killbill-bitpay/us

Mounting Knp into your own Rails app
------------------------------------

* Add `knp` to your Gemfile
* Add `mount Knp::Engine, at: "/killbill"` in your `config/routes.rb`


Configuration
-------------

### Using a configuration file

Create a file ```config/knp.yml```:

```
development:
  killbill:
    base_uri: http://127.0.0.1:8080/
    api_key: bob
    api_secret: lazar
    username: admin
    password: password
```

Check out the [symmetric-encryption](https://github.com/reidmorrison/symmetric-encryption) gem for encrypting the password.

If you have multiple Kill Bill clusters:

```
development:
  killbill:
    us:
      base_uri: http://killbill-us.acme.com:8080/
      api_key: bob_us
      api_secret: lazar_us
      username: admin
      password: password
    europe:
      base_uri: http://killbill-europe.acme:8080/
      api_key: bob_europe
      api_secret: lazar_europe
      username: admin
      password: password
```

### Using code

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
