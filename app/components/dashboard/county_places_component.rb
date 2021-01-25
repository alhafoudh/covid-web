# frozen_string_literal: true

class Dashboard::CountyPlacesComponent < ViewComponent::Base

  with_collection_parameter :county

  attr_reader :county, :places_by_county, :plan_dates

  def initialize(county:, places_by_county:, plan_dates:)
    @county = county
    @places_by_county = places_by_county
    @plan_dates = plan_dates
  end

  def render?
    places.any?
  end

  def classes
    class_names(
      'no-free-capacity': county && free_capacity_in_county.zero?
    )
  end

  def free_capacity_in_county
    places_by_county.reduce(0) do |acc, (_, places)|
      acc + places.select do |place|
        place.county == county
      end.map do |place|
        place.total_free_capacity(plan_dates)
      end.sum
    end
  end

  def title
    county&.name
  end

  def places
    @places ||= places_by_county.fetch(county, [])
  end
end
