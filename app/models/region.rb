class Region < ApplicationRecord
  has_many :counties
  has_many :moms

  def total_free_capacity(test_dates = nil)
    counties.reduce(0) do |acc, county|
      acc + county.total_free_capacity(test_dates)
    end
  end

  def any_free_capacity?(test_dates = nil)
    total_free_capacity(test_dates) > 0
  end
end
