class Region < ApplicationRecord
  has_many :counties, -> { order(name: :asc) }
  has_many :moms
  has_many :vaccs

  def total_moms_free_capacity(test_dates = nil)
    counties.reduce(0) do |acc, county|
      acc + county.total_moms_free_capacity(test_dates)
    end
  end

  def any_moms_free_capacity?(test_dates = nil)
    total_moms_free_capacity(test_dates) > 0
  end

  def total_vaccs_free_capacity(test_dates = nil)
    counties.reduce(0) do |acc, county|
      acc + county.total_vaccs_free_capacity(test_dates)
    end
  end

  def any_vaccs_free_capacity?(test_dates = nil)
    total_vaccs_free_capacity(test_dates) > 0
  end
end
