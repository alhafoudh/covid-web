class UpdateVaccVaccinationDateSnapshotsBase < ApplicationService
  protected

  def create_vaccination_date_snapshots!(snapshots)
    latest_vaccination_date_snapshots_map = vacc.latest_vaccination_date_snapshots.group_by(&:vaccination_date)
    snapshots.map do |vaccination_date_snapshot|
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
      latest_vaccination_date_snapshot.enabled = true
      latest_vaccination_date_snapshot.vaccination_date_snapshot = vaccination_date_snapshot
      latest_vaccination_date_snapshot.save!
      logger.debug "Created latest test date snapshot #{latest_vaccination_date_snapshot.inspect}"
      latest_vaccination_date_snapshot
    end
  end

  def disable_latest_vaccination_date_snapshots!(snapshots)
    vacc.latest_vaccination_date_snapshots
      .enabled
      .where.not(
      vaccination_date_id: snapshots.pluck(:vaccination_date_id),
    )
      .update_all(enabled: false)
      .tap do |num_disabled_latest_snapshots|
      logger.info "Disabled #{num_disabled_latest_snapshots} Vacc latest snapshots"
    end
  end

end