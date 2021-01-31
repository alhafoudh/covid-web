class Subscription < ApplicationRecord
  belongs_to :region

  enum channel: { messenger: 'messenger' }

  validates :channel, presence: true
  validates :user_id, presence: true

  def deliver(text)
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
    else
      raise NotImplementedError
    end
  end
end
