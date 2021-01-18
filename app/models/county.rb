class County < ApplicationRecord
  belongs_to :region, touch: true
  has_many :moms
end
