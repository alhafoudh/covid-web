# frozen_string_literal: true

class Notifications::RegionVaccinationsFreeCapacityNotification < ApplicationComponent
  attr_reader :region, :plan_date_capacities

  def initialize(region:, plan_date_capacities:)
    @region = region
    @plan_date_capacities = plan_date_capacities
  end

  def region_title
    region.present? ? region.name : nil
  end

  def region_dom_id
    region.present? ? dom_id(region) : :other_region
  end

  def region_url
    "#{vaccination_root_url}##{region_dom_id}"
  end

  def total_capacity_delta
    plan_date_capacities.map do |plan_date_capacity|
      plan_date_capacity[:current_free_capacity] - plan_date_capacity[:previous_free_capacity]
    end.sum
  end
end
