class VaccinationDate < ApplicationRecord
  validates :date, presence: true
end
