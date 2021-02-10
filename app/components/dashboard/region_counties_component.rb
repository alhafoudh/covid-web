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
    counties
      .map do |county|
      places_for(county)
    end
      .flatten
      .any? do |place|
      place.available?(plan_dates)
    end
  end

  def region_dom_id
    dom_id(region)
  end

  def counties
    region.counties
  end

  def classes
    class_names(
      'no-free-capacity': !any_available_in_region?
    )
  end

  def any_available_in_region?
    counties
      .map do |county|
      places_for(county)
    end
      .flatten
      .any? do |place|
      place.available?(plan_dates)
    end
  end

  def title
    region.name
  end

  def badge
    t(:free_capacity, count: total_free_capacity(region), formatted_count: number_with_delimiter(total_free_capacity(region)))
  end

  def total_free_capacity
    @total_free_capacity ||= (region.nil? ? [nil] : region.counties)
                               .map do |county|
      places_for(county)
    end
                               .flatten
                               .map do |place|
      place.total_free_capacity(plan_dates)
    end
                               .sum
  end

  def places_for(county)
    places_by_county.fetch(county, [])
  end
end
