require 'test_helper'

module Knp
  class MockNotificationsControllerTest < FunctionalTestHelper

    setup do
      class Knp::Notification
        alias_method :original_notify!, :notify!
        cattr_accessor :notification_response

        def notify!
          notification_response.nil? ? original_notify! : notification_response
        end
      end
    end

    teardown do
      class Knp::Notification
        alias_method :notify!, :original_notify!
      end
    end

    def test_notify_mock
      Knp::Notification.notification_response = {
          :body         => 'OK',
          :status       => '123',
          :location     => 'http://killbill.io',
          :content_type => 'notification/ok',
          :headers      => {'custom' => %w(1 2)},
      }

      post :notify, :plugin_name => 'anything'

      assert_response 123
      assert_equal 'OK', @response.body
      assert_equal 2, @response.headers.size
      assert_equal 'http://killbill.io', @response['Location']
      assert_equal 'notification/ok; charset=utf-8', @response['Content-Type']
      #assert_equal ['1', '2'], @response['custom']
    end
  end
end
