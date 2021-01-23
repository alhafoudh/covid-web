class UpdateNcziVaccVaccinationDateSnapshots < ApplicationService
  include NcziClient

  attr_reader :vacc

  def initialize(vacc:)
    @vacc = vacc
  end

  def perform
    logger.info "Updating NCZI vaccination date snapshots for vacc #{vacc.inspect}"

    ActiveRecord::Base.transaction do
      vaccination_date_snapshots = create_vacc_vaccination_date_snapshots!
      update_latest_vaccination_date_snapshots!(vaccination_date_snapshots)
    end
  end

  private

  def create_vacc_vaccination_date_snapshots!
    latest_vaccination_date_snapshots_map = vacc.latest_vaccination_date_snapshots.group_by(&:vaccination_date)
    fetch_nczi_vacc_vaccination_date_snapshots.map do |vaccination_date_snapshot|
      latest_vaccination_date_snapshot = latest_vaccination_date_snapshots_map.fetch(vaccination_date_snapshot.vaccination_date, []).first

      if vaccination_date_snapshot.different?(latest_vaccination_date_snapshot&.vaccination_date_snapshot)
        vaccination_date_snapshot.save!
        logger.debug "Created vaccination date snapshot #{vaccination_date_snapshot.inspect}"

        vaccination_date_snapshot
      else
        logger.debug "Vaccination date snapshot did not change since latest #{vaccination_date_snapshot.inspect}"
        nil
      end
    end.compact
  end

  def update_latest_vaccination_date_snapshots!(vaccination_date_snapshots)
    vaccination_date_snapshots.map do |vaccination_date_snapshot|
      latest_vaccination_date_snapshot = LatestVaccinationDateSnapshot.find_or_initialize_by(
        vacc_id: vaccination_date_snapshot.vacc_id,
        vaccination_date_id: vaccination_date_snapshot.vaccination_date_id,
      )
      latest_vaccination_date_snapshot.vaccination_date_snapshot = vaccination_date_snapshot
      latest_vaccination_date_snapshot.save!
      logger.debug "Created latest vaccination date snapshot #{latest_vaccination_date_snapshot.inspect}"
      latest_vaccination_date_snapshot
    end
  end

  def fetch_nczi_vacc_vaccination_date_snapshots
    data = fetch_nczi_snapshots
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

  def fetch_nczi_snapshots
    response = nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times_vacc', { drivein_id: vacc.external_id.to_s })
    response.body
  end
end