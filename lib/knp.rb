require 'knp/engine'

module Knp

  class Configuration

    def initialize(user_configuration_file=nil)
      @user_configuration_file = user_configuration_file
    end

    %w(base_uri api_key api_secret username password user reason comment).each do |config_key|
      define_method(config_key) do |cluster=nil|
        config_value = nil
        config_value = user_configuration_from_key('killbill', cluster, config_key) unless cluster.nil?
        config_value ||= user_configuration_from_key('killbill', config_key)
        config_value ||= send("default_#{config_key}")
        config_value
      end
    end

    protected

    def default_base_uri
      default = 'http://127.0.0.1:8080/'
      KillBillClient.url || default
    rescue KillBillClient::ConfigurationError
      default
    end

    def default_api_key
      KillBillClient.api_key || 'bob'
    end

    def default_api_secret
      KillBillClient.api_secret || 'lazar'
    end

    def default_username
      KillBillClient.username || 'admin'
    end

    def default_password
      KillBillClient.password || 'password'
    end

    def default_user
      'Knp'
    end

    def default_reason
      nil
    end

    def default_comment
      nil
    end

    private

    #
    # Return a specific key from the user configuration in config/knp.yml
    #
    # ==== Returns
    #
    # Mixed:: requested_key or nil
    #
    def user_configuration_from_key(*keys)
      keys.inject(user_configuration) do |hash, key|
        hash[key] if hash
      end
    end

    #
    # Memoized hash of configuration options for the current Rails environment
    # as specified in config/knp.yml
    #
    # ==== Returns
    #
    # Hash:: configuration options for current environment
    #
    def user_configuration
      @user_configuration ||=
          begin
            if !@user_configuration_file.nil? && File.exist?(@user_configuration_file)
              File.open(@user_configuration_file) do |file|
                processed = ERB.new(file.read).result
                YAML.load(processed)[Rails.env]
              end
            else
              {}
            end
          end
    end
  end
end
