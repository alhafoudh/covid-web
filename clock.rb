require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true

module Clockwork
  every(Rails.application.config.x.testing.update_interval.minutes, 'update_all_testing_data') do
    SkCovidTesting::Application.load_tasks

    UpdateAllNcziTestingData.new.perform
  end

  every(Rails.application.config.x.vaccination.update_interval.minutes, 'update_all_vaccination_data') do
    SkCovidTesting::Application.load_tasks

    update_result = UpdateAllNcziVaccinationData.new.perform
    latest_snapshots = update_result.flatten
    NotifyVaccinationSubscriptions.new(latest_snapshots: latest_snapshots).perform
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

