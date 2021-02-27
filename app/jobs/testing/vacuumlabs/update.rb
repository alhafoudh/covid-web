module Testing
  module Vacuumlabs
    class Update < ApplicationJob
      def perform
        UpdateSnapshots.perform_now
      end
    end
  end
end