class LatestTestDateSnapshot < ApplicationRecord
  belongs_to :mom, touch: true
  belongs_to :test_date
  belongs_to :test_date_snapshot
end
