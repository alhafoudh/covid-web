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
    places.any?(&:visible?)
  end

  def classes
    class_names(
      'no-free-capacity': !any_available_in_county?
    )
  end

  def any_available_in_county?
    places.any? do |place|
      place.available?(plan_dates)
    end
  end

  def title
    county&.name
  end

  def places
    @places ||= places_by_county.fetch(county, [])
  end
end
