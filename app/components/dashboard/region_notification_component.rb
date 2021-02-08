# frozen_string_literal: true

class Dashboard::RegionNotificationComponent < ViewComponent::Base
  attr_reader :region, :class_name

  def initialize(region:, class_name: nil)
    @region = region
    @class_name = class_name
  end

  def render?
    region.present?
  end
end
