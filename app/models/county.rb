class County < ApplicationRecord
  belongs_to :region, touch: true
  has_many :moms
  has_many :vaccs

  def total_moms_free_capacity(test_dates = nil)
    moms.reduce(0) do |acc, mom|
      acc + mom.total_moms_free_capacity(test_dates)
    end
  end

  def any_moms_free_capacity?(test_dates = nil)
    total_moms_free_capacity(test_dates) > 0
  end
end
