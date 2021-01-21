module Locatable
  extend ActiveSupport::Concern

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

end
