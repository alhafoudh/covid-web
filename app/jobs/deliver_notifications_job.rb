class DeliverNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DeliverNotifications.new(*args).perform
  end
end