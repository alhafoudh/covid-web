module Testing
  class UpdateSnapshots < ApplicationJob
    def perform
      Nczi::UpdateSnapshots.perform_now
      Rychlejsie::UpdateSnapshots.perform_now
      Vacuumlabs::UpdateSnapshots.perform_now
    end
  end
end