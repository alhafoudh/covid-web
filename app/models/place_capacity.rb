class PlaceCapacity < ApplicationRecord
  self.abstract_class = true

  # belongs_to :region
  # belongs_to :county
  #
  def readonly?
    true
  end
end
