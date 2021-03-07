module Testing
  module Rychlejsie
    class UpdatePlanDates < ApplicationJob
      attr_reader :snapshots_data

      def perform(snapshots_data:)
        @snapshots_data = snapshots_data

        logger.info 'Updating Rychlejsie Test Dates'

        ActiveRecord::Base.transaction do
          upsert_plan_dates!
        end
      end

      private

      def upsert_plan_dates!
        snapshots_data
          .map do |hour|
          Time.zone.parse(hour[:time]).to_date
        end
          .uniq
          .sort
          .map do |date|
          {
            date: date,
            created_at: Time.zone.now,
            updated_at: Time.zone.now,
          }
        end
          .tap do |snapshots_plan_dates|
          if snapshots_plan_dates.any?
            TestDate.upsert_all(snapshots_plan_dates, unique_by: :date)
          end
        end
      end
    end
  end
end