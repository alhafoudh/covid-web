class UpdateVacuumlabsMomTestDateSnapshots < UpdateMomTestDateSnapshotsBase
  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating Vacuumlabs test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      test_date_snapshots = create_test_date_snapshots!(fetch_test_date_snapshots)
      update_latest_test_date_snapshots!(test_date_snapshots)
    end
  end

  private

  def fetch_test_date_snapshots
    data = fetch_snapshots
    timeslots = data
                  .fetch('timeslots', [])
                  .map(&:symbolize_keys)

    timeslots_by_date = timeslots.group_by do |timeslot|
      date_time = Time.zone.parse(timeslot[:dateTime])
      date_time.to_date
    end

    timeslots_by_date.map do |date, date_timeslots|
      test_date = test_dates.find do |test_date|
        test_date.date == date
      end
      unless test_date.present?
        test_date = TestDate.create!(
          date: date,
        )
      end
      is_closed = date_timeslots.pluck(:state).all? do |state|
        state != 'open'
      end
      free_capacity = date_timeslots.pluck(:remainingCapacity).sum

      TestDateSnapshot.new(
        test_date: test_date,
        mom_id: mom.id,
        is_closed: is_closed,
        free_capacity: free_capacity,
      )
    end
  end

  def test_dates
    @test_dates ||= TestDate.all.to_a
  end

  def fetch_snapshots
    response = vacuumlabs_client.get("https://rychlotest-covid.sk/api/public/collection_sites/#{mom.external_id}")
    response.body
  end

  def vacuumlabs_client
    @vacuumlabs_client ||= Faraday.new do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end
end