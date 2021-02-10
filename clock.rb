require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true

module Clockwork
  every(Rails.application.config.x.update_interval.minutes, 'update_all') do
    SkCovidTesting::Application.load_tasks

    update_result = UpdateAllVaccinationData.new.perform
    # latest_snapshots = update_result.flatten
    # NotifyVaccinationSubscriptions.new(latest_snapshots: latest_snapshots).perform

    UpdateAllTestingData.new.perform
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

