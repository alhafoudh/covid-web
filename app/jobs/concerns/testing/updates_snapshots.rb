module Testing
  module UpdatesSnapshots
    extend ActiveSupport::Concern

    protected

    def create_snapshots!(snapshots)
      latest_snapshots_map = mom.latest_snapshots.group_by(&:plan_date)
      snapshots.map do |snapshot|
        latest_snapshot = latest_snapshots_map.fetch(snapshot.plan_date, []).first

        if snapshot.different?(latest_snapshot&.snapshot)
          snapshot.save!
          logger.debug "Created test date snapshot #{snapshot.inspect}"

          snapshot
        else
          logger.debug "Test date snapshot did not change since latest #{snapshot.inspect}"
          nil
        end
      end.compact
    end

    def update_latest_snapshots!(snapshots)
      snapshots.map do |snapshot|
        latest_snapshot = LatestTestDateSnapshot.find_or_initialize_by(
          mom_id: snapshot.mom_id,
          test_date_id: snapshot.test_date_id,
        )
        latest_snapshot.enabled = true
        latest_snapshot.previous_snapshot = latest_snapshot.snapshot
        latest_snapshot.snapshot = snapshot
        latest_snapshot.save!
        logger.debug "Created latest test date snapshot #{latest_snapshot.inspect}"
        latest_snapshot
      end
    end

    def disable_latest_snapshots!(snapshots)
      num_enabled_snapshots_before = mom.latest_snapshots.enabled.count
      mom.latest_snapshots.update_all(enabled: true)

      mom.latest_snapshots
        .where.not(
        test_date_id: snapshots.pluck(:test_date_id),
      )
        .update_all(enabled: false)

      num_enabled_snapshots_after = mom.latest_snapshots.enabled.count
      num_disabled_snapshots = num_enabled_snapshots_after - num_enabled_snapshots_before
      logger.info "Disabled #{num_disabled_snapshots} Mom latest snapshots"
    end
  end
end