class UpdateAllTestingData < ApplicationService
  def perform
    if Rails.application.config.x.nczi.use_batch_api
      UpdateAllTestingDataBatched.new.perform
    else
      UpdateAllTestingDataEach.new.perform
    end
  end
end