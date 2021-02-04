class UpdateAllNcziVaccinationData < ApplicationService
  include NcziClient

  def perform
    if Rails.application.config.x.nczi.use_batch_api
      UpdateAllNcziVaccinationDataBatched.new.perform
    else
      UpdateAllNcziVaccinationDataEach.new.perform
    end
  end
end