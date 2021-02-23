# frozen_string_literal: true

class Dashboard::PlacePlanCellComponent < ApplicationComponent
  with_collection_parameter :plan_date

  attr_reader :place, :plan_date

  def initialize(place:, plan_date:)
    @place = place
    @plan_date = plan_date
  end

  def classes(place, latest_snapshot, snapshot, plan_date)
    if place.supports_reservation
      if !latest_snapshot&.enabled || snapshot.nil? || snapshot.is_closed || !snapshot.available?
        'bg-red-light'
      else
        'bg-green-light'
      end
    elsif plan_date.date == Date.today
      'bg-yellow-light'
    end
  end

  def is_closed?
    !latest_snapshot&.enabled || snapshot.nil? || snapshot.is_closed
  end

  def free_capacity
    snapshot.free_capacity >= 0 ? snapshot.free_capacity : 0
  end

  def latest_snapshot
    @latest_snapshot ||= place.latest_snapshot_at(plan_date)
  end

  def snapshot
    @snapshot ||= latest_snapshot&.snapshot
  end
end
