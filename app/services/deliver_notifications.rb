class DeliverNotifications < ApplicationService
  attr_reader :channel, :user_ids, :title, :text, :extra

  def initialize(channel:, user_ids:, title: nil, text:, extra: {})
    @channel = channel
    @user_ids = user_ids.uniq
    @title = title
    @text = text
    @extra = extra
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
    user_ids
      .map do |user_id|
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
    payloads = user_ids.map do |user_id|
      # ref. https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
      {
        message: {
          token: user_id,
          # notification: {
          #   title: title,
          #   body: text,
          # },
          data: {
            id: SecureRandom.hex,
            title: title,
            body: text,
            url: 'https://www.freevision.sk',
          },
        }.merge(extra)
      }
    end
    client = Fcmpush.new(Rails.application.config.x.firebase.project_id)
    client.batch_push(payloads)
  end
end