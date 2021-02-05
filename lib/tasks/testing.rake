namespace :testing do
  desc 'Update all testing data'
  task update: [:environment] do
    UpdateAllTestingData.new.perform
  end
end