namespace :vaccination do
  desc 'Update all vaccination'
  task update: [:environment] do
    UpdateAllNcziVaccinationData.new.perform
  end

  desc 'Update all vaccination and notify'
  task update_and_notify: [:environment] do
    update_result = UpdateAllNcziVaccinationData.new.perform
    latest_snapshots = update_result.flatten
    NotifyVaccinationSubscriptions.new(latest_snapshots: latest_snapshots).perform
  end
end