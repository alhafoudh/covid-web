namespace :testing do
  namespace :moms do
    desc 'Update MOMs'
    task update: [:environment]  do
      UpdateNcziMoms.new.perform
      RychlejsieMom.instances.map do |config|
        UpdateRychlejsieMoms.new(config).perform
      end
    end
  end

  namespace :snapshots do
    desc 'Update testing snapshots'
    task update: [:environment]  do
      UpdateAllTestingSnapshots.new(rate_limit: Rails.application.config.x.testing.rate_limit).perform
    end
  end
end