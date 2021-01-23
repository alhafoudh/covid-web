class UpdateRychlejsieMomTestDateSnapshots < UpdateMomTestDateSnapshotsBase
  include RychlejsieClient

  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating Rychlejsie test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      test_date_snapshots = create_test_date_snapshots!(fetch_test_date_snapshots)
      update_latest_test_date_snapshots!(test_date_snapshots)
    end
  end

  private

  def fetch_test_date_snapshots
    slots = fetch_slots

    hours = slots.map do |slot|
      fetch_hours_in_slot(slot[:slotId])
    end.flatten

    limit_per_hour = mom.external_details.fetch('limitPer1HourSlot', 0).to_i
    free_capacity_by_date = hours.reduce({}) do |acc, hour|
      date = Time.zone.parse(hour[:time]).to_date
      registrations = hour[:registrations].to_i
      acc[date] ||= 0
      free_capacity = limit_per_hour - registrations
      acc[date] += free_capacity if free_capacity > 0
      acc
    end

    free_capacity_by_date.map do |date, free_capacity|
      test_date = test_dates.find do |test_date|
        test_date.date == date
      end
      unless test_date.present?
        test_date = TestDate.create!(
          date: date,
        )
      end

      is_closed = false
      free_capacity = free_capacity

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

  def fetch_slots
    response = rychlejsie_client.get("#{mom.external_endpoint}/api/Slot/ListDaySlotsByPlace?placeId=#{mom.external_id}")
    response
      .body
      .map(&:last)
      .map(&:symbolize_keys)
  end

  def fetch_hours_in_slot(slot_id)
    response = rychlejsie_client.get("#{mom.external_endpoint}/api/Slot/ListHourSlotsByPlaceAndDaySlotId?placeId=#{mom.external_id}&daySlotId=#{slot_id}")
    response
      .body
      .map(&:last)
      .map(&:symbolize_keys)
  end
end