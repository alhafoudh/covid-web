class Override < ApplicationRecord
  validates :matches, presence: { allow_blank: true }
  validates :replacements, presence: { allow_blank: true }
end
