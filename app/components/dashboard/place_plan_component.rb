# frozen_string_literal: true

class Dashboard::PlacePlanComponent < ViewComponent::Base
  with_collection_parameter :place

  attr_reader :place, :plan_dates

  def initialize(place:, plan_dates:)
    @place = place
    @plan_dates = plan_dates
  end

  def classes
    class_names(
      'opacity-40 no-free-capacity': place.supports_reservation && free_capacity.zero?
    )
  end

  def free_capacity
    place.total_free_capacity(plan_dates)
  end

  def cell_classes(place, latest_snapshot, snapshot, plan_date)
    return unless latest_snapshot.present?
    return unless snapshot.present?

    if place.supports_reservation
      if !latest_snapshot.enabled || snapshot.is_closed || !snapshot.available?
        'bg-red-100'
      else
        'bg-green-200'
      end
    elsif plan_date.date == Date.today
      'bg-yellow-200'
    end
  end
end
