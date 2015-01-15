module Knp
  class NotificationsController < ApplicationController

    # Catch-all
    def notify
      notification = build_notification(params[:plugin_name], params[:cluster])
      kb_response  = notification.notify!
      build_response(kb_response)
    rescue => e
      logger.warn "Error processing notification for plugin #{params[:plugin_name]}: #{e}\n\t#{e.backtrace.join("\n\t")}"
      head :bad_request
    end

    private

    def build_notification(plugin_name, cluster)
      notification             = Notification.new(cluster)
      notification.plugin_name = plugin_name
      notification.body        = request.body.read
      notification.params      = request.query_parameters
      notification.headers     = request.headers
      notification
    end

    def build_response(kb_response)
      # This could have security issues (e.g. leak of JSESSIONID). Is there a gateway that actually requires it?
      #response.headers = kb_response[:headers]

      render :text         => kb_response[:body],
             :content_type => kb_response[:content_type],
             :location     => kb_response[:location],
             :status       => kb_response[:status]
    end
  end
end
