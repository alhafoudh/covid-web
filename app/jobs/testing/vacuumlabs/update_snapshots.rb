module Testing
  module Vacuumlabs
    class UpdateSnapshots < ApplicationJob
      include VacuumlabsApi
      include RateLimits

      def perform
        ActiveRecord::Base.transaction do
          plan_dates = TestDate.all.to_a
          jobs = VacuumlabsMom
                   .all
                   .enabled
                   .includes(
                     latest_snapshots: [
                       :plan_date,
                       { snapshot: [:plan_date] }
                     ]
                   )
                   .map do |mom|
            proc do
              UpdateMomSnapshots.perform_now(
                mom: mom,
                snapshots_data: snapshots_data_for(mom),
                plan_dates: plan_dates,
              )
            end
          end

          process_rate_limited(Rails.application.config.x.testing.rate_limit, jobs)
            .flatten
        end
      end

      private

      def snapshots_data_for(mom)
        vacuumlabs_client
          .get("#{base_url}/collection_sites/#{mom.external_id}")
          .body
          .fetch('timeslots', [])
          .map(&:symbolize_keys)
      end
    end
  end
end