namespace :vaccination do
  namespace :vaccs do
    desc 'Update VACCs'
    task update: [:environment]  do
      UpdateVaccs.new.perform
    end
  end

  namespace :snapshots do
    desc 'Update vaccination snapshots'
    task update: [:environment]  do
      UpdateAllVaccinationSnapshots.new(rate_limit: Rails.application.config.x.vaccination.rate_limit).perform
    end
  end
end