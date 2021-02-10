class UpdateAllTestingDataJob < ApplicationJob
  queue_as :default

  def perform
    UpdateAllTestingData.new.perform
  end
end