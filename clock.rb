require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true

module Clockwork
  every(Rails.application.config.x.testing.update_interval.minutes, 'update_all_test_date_snapshots') do
    SkCovidTesting::Application.load_tasks
    Rake::Task['testing:moms:update'].invoke
    Rake::Task['testing:snapshots:update'].invoke
  end

  every(Rails.application.config.x.vaccination.update_interval.minutes, 'update_all_vaccination_date_snapshots') do
    SkCovidTesting::Application.load_tasks
    Rake::Task['vaccination:vaccs:update'].invoke
    Rake::Task['vaccination:snapshots:update'].invoke
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

