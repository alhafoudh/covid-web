# frozen_string_literal: true

class Dashboard::RegionCountiesComponent < ViewComponent::Base

  with_collection_parameter :region

  attr_reader :region, :places_by_county, :plan_dates

  def initialize(region:, places_by_county:, plan_dates:)
    @region = region
    @places_by_county = places_by_county
    @plan_dates = plan_dates
  end

  def render?
    !counties.all? do |county|
      places_for(county).empty?
    end
  end

  def region_dom_id
    dom_id(region)
  end

  def counties
    region.present? ? region.counties : [nil]
  end

  def classes
    class_names(
      'no-free-capacity': free_capacity_in_region.zero?
    )
  end

  def free_capacity_in_region
    places_by_county.reduce(0) do |acc, (_, places)|
      acc + places.select do |place|
        place.region == region
      end.map do |place|
        place.total_free_capacity(plan_dates)
      end.sum
    end
  end

  def title
    region.name
  end

  def places_for(county)
    places_by_county.fetch(county, [])
  end
end
