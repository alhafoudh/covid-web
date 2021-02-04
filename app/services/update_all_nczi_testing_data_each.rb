class UpdateAllNcziTestingDataEach < ApplicationService
  include NcziClient

  def perform
    logger.info "Updating all NCZI testing data (slow)"

    ActiveRecord::Base.transaction do
      update_places!
      update_snapshots!
    end
  end

  private

  def update_places!
    UpdateNcziMoms.new.perform
  end

  def update_snapshots!
    UpdateAllTestingSnapshots.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
  end
end