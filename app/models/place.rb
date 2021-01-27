class Place < ApplicationRecord
  include Locatable
  include Capacitable

  self.abstract_class = true

  belongs_to :region, counter_cache: true
  belongs_to :county, counter_cache: true, touch: true

  scope :enabled, -> { where(enabled: true) }

  def commercial?
    false
  end

  def visible?
    true
  end

  def latest_snapshot_at(plan_date)
    latest_snapshots.find do |latest_snapshot|
      latest_snapshot.plan_date == plan_date
    end
  end

  def final_reservations_url
    reservations_url.to_s % attributes.symbolize_keys
  end
end
