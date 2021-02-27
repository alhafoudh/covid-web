module Testing
  class Update < ApplicationJob
    def perform
      Nczi::Update.perform_now
      Rychlejsie::Update.perform_now
      Vacuumlabs::Update.perform_now
    end
  end
end