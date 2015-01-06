require 'test_helper'

module Knp
  class NotificationsControllerTest < FunctionalTestHelper

    # Requires the Adyen plugin to be installed
    def test_notify_adyen
      @request.env['RAW_POST_DATA'] = '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soap:Body>
    <ns1:sendNotification xmlns:ns1="http://notification.services.adyen.com">
      <ns1:notification>
        <live xmlns="http://notification.services.adyen.com">true</live>
        <notificationItems xmlns="http://notification.services.adyen.com">
          <NotificationRequestItem>
            <eventCode>REPORT_AVAILABLE</eventCode>
            <success>true</success>
          </NotificationRequestItem>
        </notificationItems>
      </ns1:notification>
    </ns1:sendNotification>
  </soap:Body>
</soap:Envelope>'

      post :notify, :plugin_name => 'killbill-adyen'

      assert_response 200
      assert_equal 'application/json; charset=utf-8', @response['Content-Type']
      assert_equal '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><SOAP-ENV:Body><sendNotificationResponse xmlns="http://notification.services.adyen.com" xmlns:ns2="http://common.services.adyen.com"><notificationResponse>[accepted]</notificationResponse></sendNotificationResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>', @response.body
    ensure
      @request.env.delete('RAW_POST_DATA')
    end
  end
end
