class Vacc < ApplicationRecord
  include Locatable

  belongs_to :region, counter_cache: true
  belongs_to :county, counter_cache: true, touch: true
  has_many :vaccination_date_snapshots
  has_many :latest_vaccination_date_snapshots

  def commercial?
    false
  end

  def latest_snapshot_at(vaccination_date)
    latest_vaccination_date_snapshots
      .map(&:vaccination_date_snapshot)
      .compact
      .select do |vaccination_date_snapshot|
      vaccination_date_snapshot.vaccination_date == vaccination_date
    end.first
  end

  def total_free_capacity(vaccination_dates = nil)
    latest_vaccination_date_snapshots.reduce(0) do |acc, latest_vaccination_date_snapshot|
      snapshot = latest_vaccination_date_snapshot&.vaccination_date_snapshot

      next acc unless snapshot.present?
      next acc if vaccination_dates.present? && !vaccination_dates.include?(snapshot.vaccination_date)

      free_capacity = if snapshot.is_closed
                        0
                      else
                        snapshot.free_capacity.to_i
                      end

      acc + (free_capacity > 0 ? free_capacity : 0)
    end
  end

  def final_reservations_url
    reservations_url.to_s % attributes.symbolize_keys
  end

  def supports_reservation
    false
  end
end
