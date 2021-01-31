class MessengerConfigurationProvider < Facebook::Messenger::Configuration::Providers::Base
  # Verify that the given verify token is valid.
  #
  # verify_token - A String describing the application's verify token.
  #
  # Returns a Boolean representing whether the verify token is valid.
  def valid_verify_token?(verify_token)
    Rails.application.config.x.messenger.verify_token == verify_token
  end

  # Find the right application secret.
  #
  # page_id - An Integer describing a Facebook Page ID.
  #
  # Returns a String describing the application secret.
  def app_secret_for(page_id)
    Rails.application.config.x.messenger.app_secret if page_id == Rails.application.config.x.messenger.page_id
  end

  # Find the right access token.
  #
  # recipient - A Hash describing the `recipient` attribute of the message coming
  #             from Facebook.
  #
  # Note: The naming of "recipient" can throw you off, but think of it from the
  # perspective of the message: The "recipient" is the page that receives the
  # message.
  #
  # Returns a String describing an access token.
  def access_token_for(recipient)
    Rails.application.config.x.messenger.access_token if recipient == Rails.application.config.x.messenger.page_id
  end

  private

  def bot
    SkCovidTesting::Bot
  end
end