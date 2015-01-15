require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  test 'configuration with defaults' do
    verify_config('http://127.0.0.1:8080/', 'bob', 'lazar', 'admin', 'password', 'Knp', nil, nil)
  end

  test 'configuration with Kill Bill client overrides' do
    KillBillClient.url        = 'http://127.0.0.1:9090/'
    KillBillClient.api_key    = 'bob-override'
    KillBillClient.api_secret = 'lazar-override'
    KillBillClient.username   = 'admin-override'
    KillBillClient.password   = 'password-override'

    verify_config('http://127.0.0.1:9090/', 'bob-override', 'lazar-override', 'admin-override', 'password-override', 'Knp', nil, nil)

    KillBillClient.url        = nil
    KillBillClient.api_key    = nil
    KillBillClient.api_secret = nil
    KillBillClient.username   = nil
    KillBillClient.password   = nil
  end

  test 'configuration with file override' do
    Dir.mktmpdir do |dir|
      file_path = File.join(dir, 'knp.yml')
      file      = File.new(file_path, 'w+')
      file.write(<<-eos)
test:
  killbill:
    base_uri: http://127.0.0.1:7070/
    api_key: bob-file-override
    api_secret: lazar-file-override
    username: admin-file-override
    password: password-file-override
      eos
      file.close

      verify_config('http://127.0.0.1:7070/', 'bob-file-override', 'lazar-file-override', 'admin-file-override', 'password-file-override', 'Knp', nil, nil, Knp::Configuration.new(file_path))
    end
  end

  test 'configuration with file and clusters override' do
    Dir.mktmpdir do |dir|
      file_path = File.join(dir, 'knp.yml')
      file      = File.new(file_path, 'w+')
      file.write(<<-eos)
test:
  killbill:
    us:
      base_uri: http://killbill-us.acme.com:8080/
      api_key: bob_us
      api_secret: lazar_us
      username: admin_us
      password: password_us
    europe:
      base_uri: http://killbill-europe.acme.com:8080/
      api_key: bob_europe
      api_secret: lazar_europe
      username: admin_europe
      password: password_europe
      eos
      file.close

      config = Knp::Configuration.new(file_path)
      verify_config('http://killbill-europe.acme.com:8080/', 'bob_europe', 'lazar_europe', 'admin_europe', 'password_europe', 'Knp', nil, nil, config, 'europe')
      verify_config('http://killbill-us.acme.com:8080/', 'bob_us', 'lazar_us', 'admin_us', 'password_us', 'Knp', nil, nil, Knp::Configuration.new(file_path), 'us')
    end
  end

  private

  def verify_config(base_uri, api_key, api_secret, username, password, user, reason, comment, config=Knp::Configuration.new, cluster=nil)
    assert_equal base_uri, config.base_uri(cluster)
    assert_equal api_key, config.api_key(cluster)
    assert_equal api_secret, config.api_secret(cluster)
    assert_equal username, config.username(cluster)
    assert_equal password, config.password(cluster)
    assert_equal user, config.user(cluster)
    assert_equal reason, config.reason(cluster)
    assert_equal comment, config.comment(cluster)
  end
end
