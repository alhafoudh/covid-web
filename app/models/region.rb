class Region < ApplicationRecord
  has_many :counties
  has_many :moms
end
