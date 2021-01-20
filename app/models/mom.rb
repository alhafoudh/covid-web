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
end
