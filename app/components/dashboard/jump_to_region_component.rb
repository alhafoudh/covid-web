# frozen_string_literal: true

class Dashboard::JumpToRegionComponent < ViewComponent::Base

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
      .any?(&:available?)
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

  def region_label(region, label: nil)
    label.present? ? label : region.name
  end

  def badge(region)
    number_with_delimiter(total_free_capacity(region))
  end

  def badge_classes(region)
    capacity = total_free_capacity(region)
    class_names(
      'bg-green-100 text-green-600': capacity >= 200,
      'bg-yellow-100 text-yellow-600': capacity >= 100 && capacity < 200,
      'bg-red-100 text-red-600': capacity < 100,
    )
  end

  def places_for(county)
    places_by_county.fetch(county, [])
  end

  def classes_for_region(region)
    class_names(
      'flex',
      'opacity-30': !any_available_in_region?(region)
    )
  end
end
