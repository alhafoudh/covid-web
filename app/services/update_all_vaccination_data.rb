class UpdateAllVaccinationData < ApplicationService
  def perform
    track_job UpdateVaccinationDataJobResult do
      if Rails.application.config.x.nczi.use_batch_api
        UpdateAllNcziVaccinationDataBatched.new.perform
      else
        UpdateAllNcziVaccinationDataEach.new.perform
      end
    end
  end
end