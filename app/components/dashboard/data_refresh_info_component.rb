# frozen_string_literal: true

class Dashboard::DataRefreshInfoComponent < ViewComponent::Base

  attr_reader :snapshot_class, :update_interval

  def initialize(snapshot_class:, update_interval:)
    @snapshot_class = snapshot_class
    @update_interval = update_interval
  end

  def render?
    snapshot_class.last_updated_at.present?
  end

  def last_updated_at
    snapshot_class.last_updated_at
  end
end
