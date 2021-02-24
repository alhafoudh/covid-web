require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |message|
  Rails.logger.debug message.inspect

  VaccinationBotOnMessageJob.perform_later(message_data: message.messaging)
end

Bot.on :postback do |message|
  Rails.logger.debug message.inspect

  VaccinationBotOnPostbackJob.perform_later(message_data: message.messaging)
end

class VaccinationBot
  attr_reader :message, :payload

  def initialize(message, payload)
    @message = message
    @payload = payload
  end

  def process
    case payload.action
    when 'start' then
      start
    when 'ask_region' then
      ask_region
    when 'ask_confirm' then
      ask_confirm
    when 'confirm' then
      confirm
    when 'cancel' then
      cancel
    when 'debug' then
      debug
    else
      dont_understand
    end
  end

  def start
    main_menu
  end

  def main_menu
    if has_schedule?
      quick_replies = [
        {
          content_type: 'text',
          title: t('bot.change'),
          payload: payload.with(action: 'ask_region').to_json,
        },
        {
          content_type: 'text',
          title: t('bot.cancel_notifications'),
          payload: payload.with(action: 'cancel').to_json,
        },
      ]
      reply t('bot.has_schedule', region: current_schedule.region.name), quick_replies: quick_replies
    else
      ask_region
    end
  end

  def ask_region
    quick_replies = Region.all.map do |region|
      {
        content_type: 'text',
        title: "📍 #{region.name}",
        payload: payload.with(action: 'ask_confirm', region_id: region.signed_id).to_json
      }
    end + [
      {
        content_type: 'text',
        title: t('bot.cancel'),
        payload: payload.with(action: 'cancel').to_json
      }
    ]
    reply t('bot.ask_region'), quick_replies: quick_replies
  end

  def ask_confirm
    quick_replies = [
      {
        content_type: 'text',
        title: t('bot.confirm'),
        payload: payload.with(action: 'confirm').to_json
      },
      {
        content_type: 'text',
        title: t('bot.cancel'),
        payload: payload.with(action: 'cancel').to_json
      },
    ]
    reply t('bot.ask_confirm', region: payload.region.name), quick_replies: quick_replies
  end

  def confirm
    unsubscribe!
    subscribe!(payload.region)

    quick_replies = [
      {
        content_type: 'text',
        title: t('bot.change'),
        payload: payload.with(action: 'start').to_json,
      },
      {
        content_type: 'text',
        title: t('bot.cancel_notifications'),
        payload: payload.with(action: 'cancel').to_json
      },
    ]
    reply t('bot.confirmed', region: payload.region.name), quick_replies: quick_replies
  end

  def cancel
    unsubscribe!

    quick_replies = [
      {
        content_type: 'text',
        title: t('bot.start_again'),
        payload: payload.with(action: 'start').to_json,
      },
    ]
    reply t('bot.cancelled'), quick_replies: quick_replies
  end

  def debug
    reply "*Message*: #{message.as_json}\n\nPayload: #{payload.as_json}"
  end

  def dont_understand
    reply t('bot.dont_understand')
    main_menu
  end

  private

  def subscribe!(region)
    subscription = VaccinationSubscription.find_or_initialize_by(
      channel: VaccinationSubscription.channels[:messenger],
      user_id: payload.user_id,
      region: region,
    )
    subscription.region = region
    subscription.save!
    subscription
  end

  def unsubscribe!
    VaccinationSubscription.destroy_by(
      channel: VaccinationSubscription.channels[:messenger],
      user_id: payload.user_id,
    )
  end

  def current_schedule
    VaccinationSubscription
      .includes(:region)
      .where(
        channel: VaccinationSubscription.channels[:messenger],
        user_id: payload.user_id,
      ).first
  end

  def has_schedule?
    current_schedule.present?
  end

  def t(key, **options)
    I18n.t(key, **options)
  end

  def reply(text, options = {})
    payload = { text: text }.merge(options)
    Rails.logger.debug("Replying to message #{message.inspect} with #{payload}")
    message.reply(payload)
  end
end