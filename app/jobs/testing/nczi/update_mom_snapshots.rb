module Testing
  module Nczi
    class UpdateMomSnapshots < ApplicationJob
      include UpdatesSnapshots

      attr_reader :mom, :snapshots_data, :plan_dates

      def perform(mom:, snapshots_data:, plan_dates:)
        @mom = mom
        @snapshots_data = snapshots_data
        @plan_dates = plan_dates

        ActiveRecord::Base.transaction do
          logger.info "Updating NCZI snapshots for mom ##{mom.id}"

          prepare_snapshots!
          created_snapshots = create_snapshots!(snapshots)
          latest_snapshots = update_latest_snapshots!(created_snapshots)
          disable_latest_snapshots!(snapshots)

          logger.info "Done updating NCZI snapshots. Currently we have #{mom.latest_snapshots.enabled.count} enabled latest snapshots."

          latest_snapshots
        end
      end

      private

      attr_reader :snapshots

      def prepare_snapshots!
        @snapshots = snapshots_data.map do |plan_date_status|
          parsed_date = Date.parse(plan_date_status['c_date'])
          plan_date = plan_dates.find do |plan_date|
            plan_date.date == parsed_date
          end

          unless plan_date.present?
            plan_date = TestDate.find_or_create_by!(
              date: parsed_date,
            )
          end

          TestDateSnapshot.new(
            plan_date: plan_date,
            mom_id: mom.id,
            is_closed: plan_date_status['is_closed'] == '1',
            free_capacity: plan_date_status.fetch('free_capacity', 0).to_i,
          )
        end
      end
    end
  end
end