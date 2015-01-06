module Knp
  class Notification

    attr_accessor :plugin_name
    attr_accessor :body
    attr_accessor :params
    attr_accessor :headers
    attr_accessor :user
    attr_accessor :reason
    attr_accessor :comment
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :username
    attr_accessor :password

    def initialize
      self.user       = Knp.user || 'Knp'
      self.reason     = Knp.reason
      self.comment    = Knp.comment
      self.api_key    = Knp.api_key
      self.api_secret = Knp.api_secret
      self.username   = Knp.username
      self.password   = Knp.password
    end

    def notify!
      # Response is a Net::HTTPResponse
      response = KillBillClient::API.post(kb_url, body, params, build_options)

      {
          :body         => response.body,
          :status       => response.code,
          # The header key is case insensitive in Net::HTTPHeader
          :location     => response['location'],
          :content_type => response.content_type,
          :headers      => response.to_hash,
      }
    end

    private

    def kb_url
      "#{KillBillClient::Model::Resource::KILLBILL_API_PREFIX}/paymentGateways/notification/#{plugin_name}"
    end

    def build_options
      # Merge after to avoid conflicts with headers passed by the gateway
      headers
          .deep_dup
          .merge(
              :user       => user,
              :reason     => reason,
              :comment    => comment,
              :api_key    => api_key,
              :api_secret => api_secret,
              :username   => username,
              :password   => password
          )
    end
  end
end
