# frozen_string_literal: true

class Dashboard::JumpToRegionComponent < ViewComponent::Base

  attr_reader :regions, :places_by_county

  def initialize(regions:, places_by_county:)
    @regions = regions
    @places_by_county = places_by_county
  end

  def any_available_in_region?(region)
    (region.nil? ? [nil] : region.counties)
      .map do |county|
      places_for(county)
    end
      .flatten
      .any?(&:available?)
  end

  def places_for(county)
    places_by_county.fetch(county, [])
  end
end
