class UpdateRychlejsieMoms < ApplicationService
  include RychlejsieClient

  attr_reader :base_url
  attr_reader :city
  attr_reader :region

  def initialize(base_url:, city:, region:)
    @base_url = base_url
    @city = city
    @region = region
  end

  def perform
    logger.tagged(base_url) do
      logger.info "Updating Rychlejsie moms from #{base_url} #{city} #{region.name}"

      ActiveRecord::Base.transaction do
        moms = fetch_moms

        update_counties!(moms)
        update_moms!(moms)
        disable_missing_moms!(moms)

        logger.info "Done updating Rychlejsie moms. Currently we have #{RychlejsieMom.enabled.count} enabled Rychlejsie moms"
      end
    end
  end

  private

  def fetch_moms
    fetch_data.map do |mom|
      address = mom[:address]
      _, street_name, postal_code, county_name = address.match(/(.+?),\ ([0-9 ]{5,6})\ (.*)/).to_a

      {
        enabled: true,
        title: mom[:name],
        longitude: mom[:lng],
        latitude: mom[:lat],
        city: city,
        street_name: street_name,
        street_number: nil,
        postal_code: postal_code,
        county_name: county_name,
        updated_at: Time.zone.now,
        reservations_url: "#{base_url}/#/place/%{external_id}",
        supports_reservation: mom[:hasReservationSystem],
        external_id: mom[:id],
        external_endpoint: base_url,
        external_details: mom,
      }
    end
  end

  def update_counties!(moms)
    counties = moms.map do |mom|
      {
        external_id: mom[:county_name],
        region_id: region.id,
        name: mom[:county_name],
      }
    end.compact.uniq

    County.upsert_all(counties, unique_by: :external_id)

    County.find_each do |county|
      County.reset_counters(county.id, :moms)
    end
  end

  def update_moms!(moms)
    updated_moms = moms.map do |mom|
      county = county_by_external_id(mom[:county_name])

      mom[:region_id] = region.id
      mom[:county_id] = county&.id
      mom[:type] = 'RychlejsieMom'

      mom
    end

    Mom.upsert_all(updated_moms, unique_by: :external_id)
  end

  def disable_missing_moms!(moms)
    RychlejsieMom
      .enabled
      .where(external_endpoint: base_url)
      .where.not(external_id: moms.pluck(:external_id))
      .update_all(enabled: false).tap do |num_disabled_moms|
      logger.info "Disabled #{num_disabled_moms} Rychlejsie.sk moms"
    end
  end

  def all_counties
    @all_counties ||= County.all
  end

  def county_by_external_id(external_id)
    return if external_id.nil?

    all_counties.find do |county|
      county.external_id == external_id
    end
  end

  def fetch_data
    response = rychlejsie_client.get("#{base_url}/api/Place/ListFiltered?availability=all&category=all")
    response
      .body
      .map(&:last)
      .map(&:symbolize_keys)
  end
end