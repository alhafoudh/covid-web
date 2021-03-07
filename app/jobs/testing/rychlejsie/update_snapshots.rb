module Testing
  module Rychlejsie
    class UpdateSnapshots < ApplicationJob
      include RychlejsieApi
      include RateLimits

      def perform
        ActiveRecord::Base.transaction do
          jobs = RychlejsieMom
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
              snapshots_data = snapshots_data_for(mom)
              UpdatePlanDates.perform_now(snapshots_data: snapshots_data)
              plan_dates = TestDate.all.to_a
              UpdateMomSnapshots.perform_now(
                mom: mom,
                snapshots_data: snapshots_data,
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
        fetch_slots(mom)
          .map do |slot|
          fetch_hours_in_slot(mom, slot[:slotId])
        end.flatten
      end

      def fetch_slots(mom)
        rychlejsie_client
          .get("#{mom.external_endpoint}/api/Slot/ListDaySlotsByPlace?placeId=#{mom.external_id}")
          .body
          .map(&:last)
          .map(&:symbolize_keys)
      end

      def fetch_hours_in_slot(mom, slot_id)
        rychlejsie_client
          .get("#{mom.external_endpoint}/api/Slot/ListHourSlotsByPlaceAndDaySlotId?placeId=#{mom.external_id}&daySlotId=#{slot_id}")
          .body
          .map(&:last)
          .map(&:symbolize_keys)
      end
    end
  end
end