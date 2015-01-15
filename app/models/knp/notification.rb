module Knp
  class Notification

    attr_accessor :plugin_name
    attr_accessor :body
    attr_accessor :params
    attr_accessor :headers
    attr_accessor :user
    attr_accessor :reason
    attr_accessor :comment
    attr_accessor :base_uri
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :username
    attr_accessor :password

    def initialize(cluster=nil)
      self.user       = KNP_CONFIG.username(cluster)
      self.reason     = KNP_CONFIG.reason(cluster)
      self.comment    = KNP_CONFIG.comment(cluster)
      self.base_uri   = URI.parse(KNP_CONFIG.base_uri(cluster))
      self.api_key    = KNP_CONFIG.api_key(cluster)
      self.api_secret = KNP_CONFIG.api_secret(cluster)
      self.username   = KNP_CONFIG.username(cluster)
      self.password   = KNP_CONFIG.password(cluster)
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
              :base_uri   => base_uri,
              :api_key    => api_key,
              :api_secret => api_secret,
              :username   => username,
              :password   => password
          )
    end
  end
end
