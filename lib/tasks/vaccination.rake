namespace :vaccination do
  namespace :all do
    desc 'Update all vaccination data'
    task update: [:environment]  do
      UpdateAllNcziVaccinationData.new.perform
    end
  end

  namespace :vaccs do
    desc 'Update VACCs'
    task update: [:environment]  do
      UpdateNcziVaccs.new.perform
    end
  end

  namespace :snapshots do
    desc 'Update vaccination snapshots'
    task update: [:environment]  do
      UpdateAllVaccinationSnapshots.new(rate_limit: Rails.application.config.x.vaccination.rate_limit).perform
    end
  end
end