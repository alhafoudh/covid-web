class UpdateNcziMoms < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating NCZI moms"

    ActiveRecord::Base.transaction do
      moms = fetch_moms
      update_regions!(moms)
      update_counties!(moms)
      update_moms!(moms)
    end
  end

  private

  def fetch_moms
    fetch_nczi_data.map do |mom|
      mom
        .merge(
          external_id: mom[:id],
          external_details: mom,
          reservations_url: 'https://www.old.korona.gov.sk/covid-19-patient-form.php',
          updated_at: Time.zone.now,
        )
        .except(:id)
    end
  end

  def update_regions!(moms)
    regions = moms.map do |mom|
      next unless mom[:region_id].present?

      {
        external_id: mom[:region_id],
        name: mom[:region_name],
      }
    end.compact.uniq

    Region.upsert_all(regions, unique_by: :external_id)

    Region.find_each do |region|
      Region.reset_counters(region.id, :moms)
    end
  end

  def update_counties!(moms)
    counties = moms.map do |mom|
      next unless mom[:county_id].present?

      region = region_by_external_id(mom[:region_id])

      {
        external_id: mom[:county_id],
        region_id: region&.id,
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
      region = region_by_external_id(mom[:region_id])
      county = county_by_external_id(mom[:county_id])

      mom[:region_id] = region&.id
      mom[:county_id] = county&.id
      mom[:type] = 'NcziMom'

      mom
    end

    Mom.upsert_all(updated_moms, unique_by: :external_id)
  end

  def all_regions
    @all_regions ||= Region.all
  end

  def region_by_external_id(external_id)
    return if external_id.nil?

    all_regions.find do |region|
      region.external_id == external_id
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

  def fetch_nczi_data
    response = nczi_client.get("#{base_url}/mom_ag.json")
    response.body.map(&:symbolize_keys)
  end
end