# frozen_string_literal: true

class Dashboard::JumpToRegionComponent < ViewComponent::Base

  attr_reader :regions

  def initialize(regions:)
    @regions = regions
  end
end
