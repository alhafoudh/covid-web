class PlanDate < ApplicationRecord
  self.abstract_class = true

  validates :date, presence: true
end
