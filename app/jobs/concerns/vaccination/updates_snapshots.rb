module Vaccination
  module UpdatesSnapshots
    extend ActiveSupport::Concern

    protected

    def create_snapshots!(snapshots)
      latest_snapshots_map = vacc.latest_snapshots.group_by(&:plan_date)
      snapshots.map do |snapshot|
        latest_snapshot = latest_snapshots_map.fetch(snapshot.plan_date, []).first

        if snapshot.different?(latest_snapshot&.snapshot)
          snapshot.save!
          logger.debug "Created vaccination date snapshot #{snapshot.inspect}"

          snapshot
        else
          logger.debug "Vaccination date snapshot did not change since latest #{snapshot.inspect}"
          nil
        end
      end.compact
    end

    def update_latest_snapshots!(snapshots)
      snapshots.map do |snapshot|
        latest_snapshot = LatestVaccinationDateSnapshot.find_or_initialize_by(
          vacc_id: snapshot.vacc_id,
          vaccination_date_id: snapshot.vaccination_date_id,
        )
        latest_snapshot.enabled = true
        latest_snapshot.previous_snapshot = latest_snapshot.snapshot
        latest_snapshot.snapshot = snapshot
        latest_snapshot.save!
        logger.debug "Created latest vaccination date snapshot #{latest_snapshot.inspect}"
        latest_snapshot
      end
    end

    def disable_latest_snapshots!(snapshots)
      num_enabled_snapshots_before = vacc.latest_snapshots.enabled.count
      vacc.latest_snapshots.update_all(enabled: true)

      vacc.latest_snapshots
        .where.not(
        vaccination_date_id: snapshots.pluck(:vaccination_date_id),
      )
        .update_all(enabled: false)

      num_enabled_snapshots_after = vacc.latest_snapshots.enabled.count
      num_disabled_snapshots = num_enabled_snapshots_after - num_enabled_snapshots_before
      logger.info "Disabled #{num_disabled_snapshots} Mom latest snapshots"
    end
  end
end