class UpdateVaccs < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating vaccs"

    ActiveRecord::Base.transaction do
      vaccs = fetch_vaccs
      update_regions!(vaccs)
      update_counties!(vaccs)
      update_vaccs!(vaccs)
    end
  end

  private

  def fetch_vaccs
    fetch_nczi_data.map do |vacc|
      vacc
        .merge(
          external_id: vacc[:id],
          reservations_url: 'https://www.old.korona.gov.sk/covid-19-vaccination-form.php',
          updated_at: Time.zone.now,
        )
        .except(:id)
    end
  end

  def update_regions!(vaccs)
    regions = vaccs.map do |vacc|
      next unless vacc[:region_id].present?

      {
        external_id: vacc[:region_id],
        name: vacc[:region_name],
      }
    end.compact.uniq

    Region.upsert_all(regions, unique_by: :external_id)

    Region.find_each do |region|
      Region.reset_counters(region.id, :vaccs)
    end
  end

  def update_counties!(vaccs)
    counties = vaccs.map do |vacc|
      next unless vacc[:county_id].present?

      region = region_by_external_id(vacc[:region_id])

      {
        external_id: vacc[:county_id],
        region_id: region&.id,
        name: vacc[:county_name],
      }
    end.compact.uniq

    County.upsert_all(counties, unique_by: :external_id)

    County.find_each do |county|
      County.reset_counters(county.id, :vaccs)
    end
  end

  def update_vaccs!(vaccs)
    updated_vaccs = vaccs.map do |vacc|
      region = region_by_external_id(vacc[:region_id])
      county = county_by_external_id(vacc[:county_id])

      vacc[:region_id] = region&.id
      vacc[:county_id] = county&.id

      vacc.except(:region_name, :county_name)
    end

    Vacc.upsert_all(updated_vaccs, unique_by: :external_id)
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
    response = nczi_client.get('https://mojeezdravie.nczisk.sk/api/v1/web/get_driveins_vacc')
    response.body.fetch('payload', []).map(&:symbolize_keys)
  end
end