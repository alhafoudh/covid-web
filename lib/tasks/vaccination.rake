namespace :vaccination do
  desc 'Update all vaccination data'
  task update: [:environment] do
    Vaccination::Update.perform_now
  end

  desc 'Update all vaccination data and notify'
  task update_and_notify: [:environment] do
    Vaccination::UpdateAndNotify.perform_now
  end
end