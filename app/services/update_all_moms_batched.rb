class UpdateAllMomsBatched < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating Moms batched"

    ActiveRecord::Base.transaction do
      fetch_all_data!
      update_places!
    end
  end

  private

  attr_reader :places_data

  def fetch_all_data!
    data = fetch_all_data_raw
    payload = data.fetch('payload', [])

    @places_data = payload.map do |record|
      record.except('calendar_data')
    end
  end

  def update_places!
    RychlejsieMom.instances.map do |config|
      UpdateRychlejsieMoms.new(config).perform
    end
    UpdateNcziMoms.new(data: places_data).perform
  end

  def fetch_all_data_raw
    response = if Rails.application.config.x.nczi.use_proxy
                 nczi_client.get('https://data.korona.gov.sk/ncziapi/get_all_drivein_times')
               else
                 nczi_client.get('https://mojeezdravie.nczisk.sk/api/v1/web/get_all_drivein_times')
               end
    response.body
  end
end