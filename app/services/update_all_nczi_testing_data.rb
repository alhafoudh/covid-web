class UpdateAllNcziTestingData < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating all NCZI testing data"

    ActiveRecord::Base.transaction do
      fetch_all_data!
      update_places!
      update_snapshots!
    end
  end

  private

  attr_reader :places_data, :snapshots_data

  def fetch_all_data!
    data = fetch_all_data_raw
    payload = data.fetch('payload', [])

    @places_data = payload.map do |record|
      record.except('calendar_data')
    end

    @snapshots_data = payload.reduce({}) do |acc, record|
      acc[record['id']] = record.fetch('calendar_data', [])
      acc
    end
  end

  def update_places!
    UpdateNcziMoms.new(data: places_data).perform
  end

  def update_snapshots!
    NcziMom
      .includes(
        latest_snapshots: [
          :plan_date,
          { snapshot: [:plan_date] }
        ]
      )
      .find_each(batch_size: 50).map do |place|
      place_snapshots_data = snapshots_data.fetch(place.external_id, [])
      UpdateNcziTestingSnapshots.new(mom: place, data: place_snapshots_data).perform
    end.flatten
  end

  def fetch_all_data_raw
    response = nczi_client.get('https://mojeezdravie.nczisk.sk/api/v1/web/get_all_drivein_times')
    response.body
  end
end