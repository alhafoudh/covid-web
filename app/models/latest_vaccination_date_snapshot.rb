class LatestVaccinationDateSnapshot < ApplicationRecord
  belongs_to :vacc
  belongs_to :vaccination_date
  belongs_to :vaccination_date_snapshot

  scope :enabled, -> { where(enabled: true) }

  def snapshot
    vaccination_date_snapshot
  end
end
