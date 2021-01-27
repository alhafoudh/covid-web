class LatestSnapshot < ApplicationRecord
  self.abstract_class = true

  scope :enabled, -> { where(enabled: true) }
end
