class County < ApplicationRecord
  has_paper_trail

  belongs_to :region, touch: true
  has_many :moms
  has_many :vaccs
end
