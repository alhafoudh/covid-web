module Vaccination
  class UpdateAndNotify < ApplicationJob
    def perform
      Nczi::Update.perform_now
        .tap do |latest_snapshots|
        NotifySubscriptions.perform_now(latest_snapshots: latest_snapshots)
      end
    end
  end
end