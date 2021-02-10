class UpdateAllVaccinationDataAndNotifyJob < ApplicationJob
  queue_as :default

  def perform
    update_result = UpdateAllVaccinationData.new.perform
    latest_snapshots = update_result.flatten

    if Rails.application.config.x.notifications.enabled
      NotifyVaccinationSubscriptions
        .new(latest_snapshots: latest_snapshots)
        .perform
    end
  end
end