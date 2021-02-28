module Vaccination
  module Nczi
    class Update < ApplicationJob
      def perform
        UpdateVaccs.perform_now
        UpdateSnapshots.perform_now
      end
    end
  end
end