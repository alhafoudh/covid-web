namespace :testing do
  desc 'Update all testing data'
  task update: [:environment] do
    Testing::Update.perform_now
  end
end