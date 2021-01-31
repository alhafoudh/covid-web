Rails.application.reloader.to_prepare do
  require Rails.root.join('app/bot/vaccination_bot.rb')
end

Rails.application.config.after_initialize do
  Facebook::Messenger.configure do |config|
    config.provider = MessengerConfigurationProvider.new
  end

  Facebook::Messenger::Profile.unset(
    {
      fields: %w[persistent_menu],
    },
    access_token: Rails.application.config.x.messenger.access_token
  )

  Facebook::Messenger::Profile.set(
    {
      get_started: {
        payload: UserVaccinationNotificationPayload.new(action: 'start').to_json
      },
      greeting: [
        {
          locale: 'default',
          text: I18n.t('bot.greeting')
        },
      ],
    },
    access_token: Rails.application.config.x.messenger.access_token
  )
end
