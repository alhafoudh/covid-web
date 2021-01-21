class County < ApplicationRecord
  belongs_to :region, touch: true
  has_many :moms

  def total_free_capacity(test_dates = nil)
    moms.reduce(0) do |acc, mom|
      acc + mom.total_free_capacity(test_dates)
    end
  end

  def any_free_capacity?(test_dates = nil)
    total_free_capacity(test_dates) > 0
  end
end
