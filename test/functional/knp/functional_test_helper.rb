module Knp
  class FunctionalTestHelper < ActionController::TestCase

    setup do
      @routes     = Engine.routes
      @controller = NotificationsController.new
    end
  end
end
