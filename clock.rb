require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true

module Clockwork
  every(Rails.application.config.x.testing.update_interval.minutes, 'update_all_test_date_snapshots') do
    SkCovidTesting::Application.load_tasks

    UpdateNcziMoms.new.perform
    RychlejsieMom.instances.map do |config|
      UpdateRychlejsieMoms.new(config).perform
    end
    UpdateAllTestingSnapshots.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
  end

  every(Rails.application.config.x.vaccination.update_interval.minutes, 'update_all_vaccination_date_snapshots') do
    SkCovidTesting::Application.load_tasks

    UpdateVaccs.new.perform
    UpdateAllVaccinationSnapshots.new(rate_limit: Rails.application.config.x.vaccination.rate_limit).perform
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

