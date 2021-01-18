require 'clockwork'
require './config/boot'
require './config/environment'

Thread.report_on_exception = true


module Clockwork
  UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL', 15).to_i
  UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT', 1).to_i

  every(UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL.minutes, 'update_all_test_date_snapshots') do
    UpdateAllMomTestDateSnapshots.new(rate_limit: UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT).perform
  end

  error_handler do |error|
    Rails.logger.error(error)
  end
end

