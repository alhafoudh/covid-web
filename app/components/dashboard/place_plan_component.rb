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

    class_names(
      'bg-red-100': latest_snapshot.enabled && !snapshot.available?,
      'bg-green-200': latest_snapshot.enabled && snapshot.available?,
      'bg-yellow-200': !latest_snapshot.enabled || !place.supports_reservation && plan_date.date == Date.today,
    )
  end
end
