class Subscription < ApplicationRecord
  belongs_to :region

  enum channel: { messenger: 'messenger', webpush: 'webpush' }

  validates :channel, presence: true
  validates :user_id, presence: true

  def deliver(text, title: nil)
    case channel
    when 'messenger' then
      Bot.deliver({
        recipient: {
          id: user_id
        },
        message: {
          text: text
        },
        messaging_type: Facebook::Messenger::Bot::MessagingType::UPDATE
      }, page_id: Rails.application.config.x.messenger.page_id)
    when 'webpush' then
      options = {
        notification: {
          title: title,
          body: text
        }
      }
      fcm.send([user_id], options)
    else
      raise NotImplementedError
    end
  end

  private

  def fcm
    FCM.new(Rails.application.config.x.firebase.server_key)
  end
end
