class TestDateSnapshot < Snapshot
  belongs_to :place, class_name: 'Mom', foreign_key: 'mom_id'
  belongs_to :plan_date, class_name: 'TestDate', foreign_key: 'test_date_id'
end
