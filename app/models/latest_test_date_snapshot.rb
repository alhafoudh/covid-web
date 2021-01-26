class LatestTestDateSnapshot < ApplicationRecord
  belongs_to :mom, touch: true
  belongs_to :test_date
  belongs_to :test_date_snapshot

  scope :enabled, -> { where(enabled: true) }

  def snapshot
    test_date_snapshot
  end
end
