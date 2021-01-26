# frozen_string_literal: true

class Dashboard::PlacePlanComponent < ViewComponent::Base
  with_collection_parameter :place

  attr_reader :place, :plan_dates

  def initialize(place:, plan_dates:)
    @place = place
    @plan_dates = plan_dates
  end

  def render?
    place.visible?
  end

  def classes
    class_names(
      'opacity-40 no-free-capacity': !available?
    )
  end

  def available?
    place.available?(plan_dates)
  end
end
