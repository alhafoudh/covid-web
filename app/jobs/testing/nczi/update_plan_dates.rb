module Testing
  module Nczi
    class UpdatePlanDates < ApplicationJob
      attr_reader :snapshots_data

      def perform(snapshots_data:)
        @snapshots_data = snapshots_data

        logger.info 'Updating NCZI Test Dates'

        ActiveRecord::Base.transaction do
          upsert_plan_dates!
        end
      end

      private

      def upsert_plan_dates!
        snapshots_data
          .pluck('c_date')
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
          TestDate.upsert_all(snapshots_plan_dates, unique_by: :date)
        end
      end
    end
  end
end