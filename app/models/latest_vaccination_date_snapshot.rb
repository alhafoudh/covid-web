class LatestVaccinationDateSnapshot < ApplicationRecord
  belongs_to :vacc
  belongs_to :vaccination_date
  belongs_to :vaccination_date_snapshot
end
