class UpdateNcziVaccVaccinationDateSnapshots < UpdateVaccVaccinationDateSnapshotsBase
  include NcziClient

  attr_reader :vacc

  def initialize(vacc:)
    @vacc = vacc
  end

  def perform
    logger.info "Updating NCZI vaccination date snapshots for vacc #{vacc.inspect}"

    ActiveRecord::Base.transaction do
      snapshots = fetch_vaccination_date_snapshots
      vaccination_date_snapshots = create_vaccination_date_snapshots!(snapshots)
      update_latest_vaccination_date_snapshots!(vaccination_date_snapshots)
      disable_latest_vaccination_date_snapshots!(snapshots)

      logger.info "Done updating NCZI vaccination date snapshots. Currently we have #{vacc.latest_vaccination_date_snapshots.enabled.count} enabled latest vaccination date snapshots."
    end
  end

  private

  def fetch_vaccination_date_snapshots
    data = fetch_snapshots
    vaccination_dates_status = data.fetch('payload', [])

    vaccination_dates_status.map do |vaccination_date_status|
      parsed_date = Date.parse(vaccination_date_status['c_date'])
      vaccination_date = vaccination_dates.find do |vaccination_date|
        vaccination_date.date == parsed_date
      end

      unless vaccination_date.present?
        vaccination_date = VaccinationDate.create!(
          date: parsed_date,
        )
      end

      VaccinationDateSnapshot.new(
        vaccination_date: vaccination_date,
        vacc_id: vacc.id,
        is_closed: vaccination_date_status['is_closed'] == '1',
        free_capacity: vaccination_date_status.fetch('free_capacity', 0).to_i,
      )
    end
  end

  def vaccination_dates
    @vaccination_dates ||= VaccinationDate.all.to_a
  end

  def fetch_snapshots
    response = nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times_vacc', { drivein_id: vacc.external_id.to_s })
    response.body
  end
end