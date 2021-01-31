namespace :messenger do
  namespace :profile do
    desc 'Setup Facebook Messenger profile'
    task setup: [:environment]  do
      Facebook::Messenger::Profile.unset(
        {
          fields: %w[persistent_menu],
        },
        access_token: Rails.application.config.x.messenger.access_token
      )

      Facebook::Messenger::Profile.set(
        {
          get_started: {
            payload: UserVaccinationFlow.new(action: 'start').to_json
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
  end
end