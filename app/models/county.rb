class County < ApplicationRecord
  belongs_to :region, touch: true
  has_many :moms
  has_many :vaccs
end
