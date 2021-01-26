class UpdateNcziMomTestDateSnapshots < UpdateMomTestDateSnapshotsBase
  include NcziClient

  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating NCZI test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      test_date_snapshots = create_test_date_snapshots!(fetch_test_date_snapshots)
      update_latest_test_date_snapshots!(test_date_snapshots)
    end
  end

  private

  def fetch_test_date_snapshots
    data = fetch_snapshots
    test_dates_status = data.fetch('payload', [])

    test_dates_status.map do |test_date_status|
      parsed_date = Date.parse(test_date_status['c_date'])
      test_date = test_dates.find do |test_date|
        test_date.date == parsed_date
      end

      unless test_date.present?
        test_date = TestDate.find_or_create_by!(
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

  def fetch_snapshots
    response = nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times', { drivein_id: mom.external_id.to_s })
    response.body
  end
end