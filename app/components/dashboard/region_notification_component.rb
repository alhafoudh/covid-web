# frozen_string_literal: true

class Dashboard::RegionNotificationComponent < ViewComponent::Base
  attr_reader :region

  def initialize(region:)
    @region = region
  end
end
