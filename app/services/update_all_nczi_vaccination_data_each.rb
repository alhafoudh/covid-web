class UpdateAllNcziVaccinationDataEach < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating all NCZI vaccination data (slow)"

    ActiveRecord::Base.transaction do
      update_places!
      update_snapshots!
    end
  end

  private

  def update_places!
    UpdateNcziVaccs.new.perform
  end

  def update_snapshots!
    UpdateAllVaccinationSnapshots.new(rate_limit: Rails.application.config.x.vaccination.rate_limit).perform
  end
end