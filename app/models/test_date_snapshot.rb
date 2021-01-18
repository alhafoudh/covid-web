class TestDateSnapshot < ApplicationRecord
  belongs_to :mom
  belongs_to :test_date

  def available?
    !is_closed && free_capacity > 0
  end

  def different?(other)
    other.nil? ||
      other.test_date.id != self.test_date.id ||
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
