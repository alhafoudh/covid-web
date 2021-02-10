class NotificationsController < ApplicationController
  layout false

  def url_options
    {
      host: Rails.application.config.x.notifications.link_host
    }
  end
end
