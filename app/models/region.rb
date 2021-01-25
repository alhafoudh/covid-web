class Region < ApplicationRecord
  has_many :counties, -> { order(name: :asc) }
  has_many :moms
  has_many :vaccs

  def all_moms_support_reservation?
    moms.all?(&:supports_reservation)
  end
end
