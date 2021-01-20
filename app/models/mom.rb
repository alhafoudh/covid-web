class Mom < ApplicationRecord
  belongs_to :region, counter_cache: true
  belongs_to :county, counter_cache: true, touch: true
  has_many :test_date_snapshots
  has_many :latest_test_date_snapshots

  def address
    [
      street_address
    ].compact
      .reject(&:blank?)
      .join(', ')
  end

  def address_full
    [
      street_address,
      city
    ].compact
      .reject(&:blank?)
      .join(', ')
  end

  def street_address
    [street_name, street_number]
      .compact
      .reject(&:blank?)
      .join(' ')
  end

  def map_url
    "https://maps.google.com/?q=#{CGI.escape(address_full)}"
  end

  def latest_snapshot_at(test_date)
    latest_test_date_snapshots
      .map(&:test_date_snapshot)
      .compact
      .select do |test_date_snapshot|
      test_date_snapshot.test_date == test_date
    end.first
  end

  def commercial?
    false
  end

  def total_free_capacity(test_dates = nil)
    latest_test_date_snapshots.reduce(0) do |acc, latest_test_date_snapshot|
      snapshot = latest_test_date_snapshot&.test_date_snapshot

      next acc unless snapshot.present?
      next acc if test_dates.present? && !test_dates.include?(snapshot.test_date)

      free_capacity = if snapshot.is_closed
                        0
                      else
                        snapshot.free_capacity.to_i
                      end

      acc + (free_capacity > 0 ? free_capacity : 0)
    end
  end

  def any_free_capacity?(test_dates = nil)
    total_free_capacity(test_dates) > 0
  end
end
