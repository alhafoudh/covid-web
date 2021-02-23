# frozen_string_literal: true

class Dashboard::JumpToRegionComponent < ApplicationComponent

  attr_reader :regions, :places_by_county, :plan_dates

  def initialize(regions:, places_by_county:, plan_dates:)
    @regions = regions
    @places_by_county = places_by_county
    @plan_dates = plan_dates
  end

  def any_available_in_region?(region)
    (region.nil? ? [nil] : region.counties)
      .map do |county|
      places_for(county)
    end
      .flatten
      .any? do |place|
      place.available?(plan_dates)
    end
  end

  def total_free_capacity(region)
    (region.nil? ? [nil] : region.counties)
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

  def classes_for_region(region)
    class_names(
      'opacity-30': !any_available_in_region?(region)
    )
  end

  def region_dom_id(region)
    region.present? ? dom_id(region) : 'other_region'
  end

  def region_label(region)
    region.present? ? region.name : t(:other_region)
  end
end
