class UpdateVacuumlabsTestingSnapshots < TestingSnapshotsBase
  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating Vacuumlabs test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      snapshots = create_snapshots!(fetch_snapshots)
      update_latest_snapshots!(snapshots)
    end
  end

  private

  def fetch_snapshots
    data = fetch_raw_snapshots
    timeslots = data
                  .fetch('timeslots', [])
                  .map(&:symbolize_keys)

    timeslots_by_date = timeslots.group_by do |timeslot|
      date_time = Time.zone.parse(timeslot[:dateTime])
      date_time.to_date
    end

    timeslots_by_date.map do |date, date_timeslots|
      plan_date = plan_dates.find do |plan_date|
        plan_date.date == date
      end
      unless plan_date.present?
        plan_date = TestDate.find_or_create_by!(
          date: date,
        )
      end
      is_closed = date_timeslots.pluck(:state).all? do |state|
        state != 'open'
      end
      free_capacity = date_timeslots.pluck(:remainingCapacity).sum

      TestDateSnapshot.new(
        plan_date: plan_date,
        mom_id: mom.id,
        is_closed: is_closed,
        free_capacity: free_capacity,
      )
    end
  end

  def plan_dates
    @plan_dates ||= TestDate.all.to_a
  end

  def fetch_raw_snapshots
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