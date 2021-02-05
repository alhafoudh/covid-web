class UpdateAllTestingDataEach < ApplicationService
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
    # Vacuumlabs moms are manually created
    RychlejsieMom.instances.map do |config|
      UpdateRychlejsieMoms.new(config).perform
    end
    UpdateNcziMoms.new.perform
  end

  def update_snapshots!
    UpdateAllNcziTestingSnapshotsEach.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
    UpdateAllVacuumlabsTestingSnapshotsEach.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
    UpdateAllRychlejsieTestingSnapshotsEach.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
  end
end