class UpdateMoms < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating moms"

    ActiveRecord::Base.transaction do
      update_moms!
      update_regions!
      update_counties!
    end
  end

  private

  def update_moms!
    moms = fetch_nczi_data.map do |mom|
      mom.symbolize_keys
        .merge(updated_at: Time.zone.now)
    end

    Mom.upsert_all(moms, unique_by: :id)
  end

  def update_regions!
    regions = Mom
                .pluck(:region_id, :region_name)
                .uniq
                .reject do |(region_id, _)|
      region_id.nil?
    end
                .map do |(region_id, region_name)|
      {
        id: region_id,
        name: region_name,
      }
    end

    Region.upsert_all(regions, unique_by: :id)

    Region.find_each do |region|
      Region.reset_counters(region.id, :moms)
    end
  end

  def update_counties!
    counties = Mom
                 .pluck(:region_id, :county_id, :county_name)
                 .uniq
                 .reject do |(_, county_id, _)|
      county_id.nil?
    end
                 .map do |(region_id, county_id, county_name)|
      {
        region_id: region_id,
        id: county_id,
        name: county_name,
      }
    end

    County.upsert_all(counties)

    County.find_each do |county|
      County.reset_counters(county.id, :moms)
    end
  end

  def fetch_nczi_data
    response = nczi_client.get('https://www.old.korona.gov.sk/mom_ag.json')
    response.body
  end
end