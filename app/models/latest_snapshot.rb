class LatestSnapshot < ApplicationRecord
  self.abstract_class = true

  has_paper_trail

  scope :enabled, -> { where(enabled: true) }
end
