class VaccinationDateSnapshot < ApplicationRecord
  belongs_to :vacc
  belongs_to :vaccination_date

  def available?
    !is_closed && free_capacity > 0
  end

  def different?(other)
    other.nil? ||
      other.vaccination_date.id != self.vaccination_date.id ||
      other.is_closed != self.is_closed ||
      other.free_capacity != self.free_capacity
  end

  def self.last_updated
    order(created_at: :desc).first
  end

  def self.last_updated_at
    last_updated&.created_at
  end
end
