class VaccinationBotOnMessageJob < ApplicationJob
  queue_as :default

  def perform(message_data:)
    message = Facebook::Messenger::Incoming::Message.new(message_data)
    payload = UserVaccinationFlow.from_message(message)
    bot = VaccinationBot.new(message, payload)
    bot.process
  end
end