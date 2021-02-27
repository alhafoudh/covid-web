module Testing
  module Nczi
    class UpdateSnapshots < ApplicationJob
      include NcziApi
      include RateLimits

      def perform
        ActiveRecord::Base.transaction do
          plan_dates = TestDate.all.to_a
          jobs = NcziMom
                   .all
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
        @all_snapshots ||= begin
                             nczi_client
                               .get("#{base_url}/get_all_drivein_times")
                               .body
                               .fetch('payload', [])
                               .reduce({}) do |acc, record|
                               acc[record['id']] = record.fetch('calendar_data', [])
                               acc
                             end
                           end

        @all_snapshots.fetch(mom.external_id, [])
      end
    end
  end
end