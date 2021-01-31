Rails.application.reloader.to_prepare do
  require Rails.root.join('app/bot/vaccination_bot.rb')
end

Rails.application.config.after_initialize do
  Facebook::Messenger.configure do |config|
    config.provider = MessengerConfigurationProvider.new
  end
end
