module Vaccination
  class Update < ApplicationJob
    def perform
      Nczi::Update.perform_now
    end
  end
end