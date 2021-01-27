class LatestTestDateSnapshot < LatestSnapshot
  belongs_to :place, class_name: 'Mom', foreign_key: 'mom_id', touch: true

  belongs_to :plan_date, class_name: 'TestDate', foreign_key: 'test_date_id'
  belongs_to :snapshot, class_name: 'TestDateSnapshot', foreign_key: 'test_date_snapshot_id'
end
