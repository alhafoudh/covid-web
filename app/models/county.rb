class County < ApplicationRecord
  belongs_to :region, touch: true
  has_many :moms
  has_many :vaccs

  def total_moms_free_capacity(test_dates = nil)
    moms.reduce(0) do |acc, mom|
      acc + mom.total_free_capacity(test_dates)
    end
  end

  def all_moms_support_reservation?
    moms.all?(&:supports_reservation)
  end

  def any_moms_free_capacity?(test_dates = nil)
    !all_moms_support_reservation? || total_moms_free_capacity(test_dates) > 0
  end

  def total_vaccs_free_capacity(test_dates = nil)
    vaccs.reduce(0) do |acc, vacc|
      acc + vacc.total_free_capacity(test_dates)
    end
  end

  def any_vaccs_free_capacity?(test_dates = nil)
    total_vaccs_free_capacity(test_dates) > 0
  end
end
