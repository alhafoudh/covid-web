require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true

module Clockwork
  every(Rails.application.config.x.update_interval.minutes, 'update_all') do
    SkCovidTesting::Application.load_tasks

    UpdateAllVaccinationDataAndNotifyJob.perform_later
    UpdateAllTestingDataJob.perform_later
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

