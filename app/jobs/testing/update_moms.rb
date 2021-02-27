module Testing
  class UpdateMoms < ApplicationJob
    def perform
      Nczi::UpdateMoms.perform_now
      Rychlejsie::UpdateMoms.perform_now
    end
  end
end