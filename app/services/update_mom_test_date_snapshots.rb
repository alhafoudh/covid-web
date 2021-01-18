class UpdateMomTestDateSnapshots < ApplicationService
  include NcziClient

  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      test_date_snapshots = update_mom_test_date_snapshots!
      update_mom_latest_test_date_snapshots!(test_date_snapshots)
    end
  end

  private

  def update_mom_test_date_snapshots!
    latest_test_date_snapshots_map = mom.latest_test_date_snapshots.group_by(&:test_date)
    fetch_mom_test_date_snapshots.map do |test_date_snapshot|
      latest_test_date_snapshot = latest_test_date_snapshots_map.fetch(test_date_snapshot.test_date, []).first

      if test_date_snapshot.different?(latest_test_date_snapshot&.test_date_snapshot)
        test_date_snapshot.save!
        logger.debug "Created test date snapshot #{test_date_snapshot.inspect}"

        test_date_snapshot
      else
        logger.debug "Test date snapshot did not change since latest #{test_date_snapshot.inspect}"
        nil
      end
    end.compact
  end

  def update_mom_latest_test_date_snapshots!(test_date_snapshots)
    test_date_snapshots.map do |test_date_snapshot|
      latest_test_date_snapshot = LatestTestDateSnapshot.find_or_initialize_by(
        mom_id: test_date_snapshot.mom_id,
        test_date_id: test_date_snapshot.test_date_id,
      )
      latest_test_date_snapshot.test_date_snapshot = test_date_snapshot
      latest_test_date_snapshot.save!
      logger.debug "Created latest test date snapshot #{latest_test_date_snapshot.inspect}"
      latest_test_date_snapshot
    end
  end

  def fetch_mom_test_date_snapshots
    data = fetch_nczi_data
    test_dates_status = data.fetch('payload', [])

    test_dates_status.map do |test_date_status|
      parsed_date = Date.parse(test_date_status['c_date'])
      test_date = test_dates.find do |test_date|
        test_date.date == parsed_date
      end

      unless test_date.present?
        test_date = TestDate.create!(
          date: parsed_date,
        )
      end

      TestDateSnapshot.new(
        test_date: test_date,
        mom_id: mom.id,
        is_closed: test_date_status['is_closed'] == '1',
        free_capacity: test_date_status.fetch('free_capacity', 0).to_i,
      )
    end
  end

  def test_dates
    @test_dates ||= TestDate.all.to_a
  end

  def fetch_nczi_data
    response = nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times', { drivein_id: mom.id.to_s })
    response.body
  end
end