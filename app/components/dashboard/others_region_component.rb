# frozen_string_literal: true

class Dashboard::OthersRegionComponent < ViewComponent::Base

  attr_reader :places_by_county, :plan_dates

  def initialize(places_by_county:, plan_dates:)
    @places_by_county = places_by_county
    @plan_dates = plan_dates
  end

  def places
    @places ||= places_by_county.fetch(nil, [])
  end

  def render?
    places.any?
  end
end
