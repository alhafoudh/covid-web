module Testing
  module Nczi
    class Update < ApplicationJob
      def perform
        UpdateMoms.perform_now
        UpdateSnapshots.perform_now
      end
    end
  end
end