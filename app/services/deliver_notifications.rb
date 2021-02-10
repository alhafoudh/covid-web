class DeliverNotifications < ApplicationService
  attr_reader :channel, :user_ids, :title, :text

  def initialize(channel:, user_ids:, title: nil, text: )
    @channel = channel
    @user_ids = user_ids
    @title = title
    @text = text
  end

  def perform
    deliver!
  end

  private

  def deliver!
    case channel
    when 'messenger' then
      deliver_messenger!
    when 'webpush' then
      deliver_webpush!
    else
      raise NotImplementedError
    end
  end

  def deliver_messenger!
    # TODO: use batching!
    user_ids.map do |user_id|
      Bot.deliver({
        recipient: {
          id: user_id
        },
        message: {
          text: text,
        },
        messaging_type: Facebook::Messenger::Bot::MessagingType::UPDATE,
      }, page_id: Rails.application.config.x.messenger.page_id)
    end
  end

  def deliver_webpush!
    FCM
      .new(Rails.application.config.x.firebase.server_key)
      .send(user_ids, {
        notification: {
          title: title,
          body: text
        }
      })
  end
end