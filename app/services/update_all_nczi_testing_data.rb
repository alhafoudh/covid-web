class UpdateAllNcziTestingData < ApplicationService
  include NcziClient

  def perform
    if Rails.application.config.x.nczi.use_batch_api
      UpdateAllNcziTestingDataBatched.new.perform
    else
      UpdateAllNcziTestingDataEach.new.perform
    end
  end
end