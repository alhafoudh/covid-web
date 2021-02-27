namespace :testing do
  desc 'Update all testing data'
  task update: [:environment] do
    Testing::Nczi::UpdateMoms.perform_now
    Testing::Nczi::UpdateAllMomSnapshots.perform_now

    Testing::Rychlejsie::UpdateMoms.perform_now
    Testing::Rychlejsie::UpdateAllMomSnapshots.perform_now

    Testing::Vacuumlabs::UpdateAllMomSnapshots.perform_now
  end
end