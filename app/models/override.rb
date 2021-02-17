class Override < ApplicationRecord
  validates :name, presence: true
  validates :matches, presence: { allow_blank: true }
  validates :replacements, presence: { allow_blank: true }

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
end
