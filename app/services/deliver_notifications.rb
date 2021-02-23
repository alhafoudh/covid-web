class DeliverNotifications < ApplicationService
  attr_reader :channel, :user_ids, :notification

  def initialize(channel:, user_ids:, **notification)
    @channel = channel
    @user_ids = user_ids.uniq
    @notification = notification
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
    # # TODO: use batching!
    user_ids
      .map do |user_id|
      Bot.deliver({
        recipient: {
          id: user_id
        },
        message: {
          text: notification[:body],
        },
        messaging_type: Facebook::Messenger::Bot::MessagingType::UPDATE,
      }, page_id: Rails.application.config.x.messenger.page_id)
    end
  end

  def deliver_webpush!
    user_ids
      .in_groups_of(500, false)
      .map do |group|
      payloads = group.map do |user_id|
        # ref. https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
        {
          message: {
            token: user_id,
          }.merge(notification)
        }
      end
      client = Fcmpush.new(Rails.application.config.x.firebase.project_id)
      client.batch_push(payloads)
    end
  end
end
