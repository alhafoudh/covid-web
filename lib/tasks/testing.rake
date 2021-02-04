namespace :testing do
  desc 'Update all testing data'
  task update: [:environment] do
    UpdateAllNcziTestingData.new.perform
  end
end