# frozen_string_literal: true

class Dashboard::OthersRegionComponent < Dashboard::RegionCountiesComponent

  attr_reader :places_by_county, :plan_dates

  def initialize(places_by_county:, plan_dates:)
    super(region: nil, places_by_county: places_by_county, plan_dates: plan_dates)
  end

  def region_dom_id
    :other_region
  end

  def counties
    [nil]
  end

  def title
    t(:other_region)
  end
end
