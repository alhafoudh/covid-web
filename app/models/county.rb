class County < ApplicationRecord
  belongs_to :region
  has_many :moms
end
