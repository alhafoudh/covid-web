class PlanDate < ApplicationRecord
  self.abstract_class = true

  has_paper_trail

  validates :date, presence: true
end
