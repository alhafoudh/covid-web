class Mom < ApplicationRecord
  belongs_to :county, counter_cache: true

  def address
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
    "https://maps.google.com/?q=#{CGI.escape(address)}"
  end
end
