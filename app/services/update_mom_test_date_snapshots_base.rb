class UpdateMomTestDateSnapshotsBase < ApplicationService
  protected

  def update_mom_test_date_snapshots!(snapshots)
    latest_test_date_snapshots_map = mom.latest_test_date_snapshots.group_by(&:test_date)
    snapshots.map do |test_date_snapshot|
      latest_test_date_snapshot = latest_test_date_snapshots_map.fetch(test_date_snapshot.test_date, []).first

      if test_date_snapshot.different?(latest_test_date_snapshot&.test_date_snapshot)
        test_date_snapshot.save!
        logger.debug "Created test date snapshot #{test_date_snapshot.inspect}"

        test_date_snapshot
      else
        logger.debug "Test date snapshot did not change since latest #{test_date_snapshot.inspect}"
        nil
      end
    end.compact
  end

  def update_mom_latest_test_date_snapshots!(test_date_snapshots)
    test_date_snapshots.map do |test_date_snapshot|
      latest_test_date_snapshot = LatestTestDateSnapshot.find_or_initialize_by(
        mom_id: test_date_snapshot.mom_id,
        test_date_id: test_date_snapshot.test_date_id,
      )
      latest_test_date_snapshot.test_date_snapshot = test_date_snapshot
      latest_test_date_snapshot.save!
      logger.debug "Created latest test date snapshot #{latest_test_date_snapshot.inspect}"
      latest_test_date_snapshot
    end
  end

end