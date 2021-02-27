module Testing
  module Vacuumlabs
    class UpdateMomSnapshots < ApplicationJob
      include UpdatesSnapshots

      attr_reader :mom, :snapshots_data, :plan_dates

      def perform(mom:, snapshots_data:, plan_dates:)
        @mom = mom
        @snapshots_data = snapshots_data
        @plan_dates = plan_dates


        ActiveRecord::Base.transaction do
          logger.info "Updating Vacuumlabs snapshots for mom ##{mom.id}"

          snapshots = create_snapshots!(prepare_snapshots!)
          update_latest_snapshots!(snapshots)

          logger.info "Done updating Vacuumlabs snapshots. Currently we have #{mom.latest_snapshots.enabled.count} enabled latest snapshots."
        end
      end

      private

      attr_reader :snapshots

      def prepare_snapshots!
        @snapshots = snapshots_data
                       .group_by do |timeslot|
          date_time = Time.zone.parse(timeslot[:dateTime])
          date_time.to_date
        end
                       .map do |date, date_timeslots|
          plan_date = plan_dates.find do |plan_date|
            plan_date.date == date
          end
          unless plan_date.present?
            plan_date = TestDate.find_or_create_by!(
              date: date,
            )
          end
          is_closed = date_timeslots.pluck(:state).all? do |state|
            state != 'open'
          end
          free_capacity = date_timeslots.pluck(:remainingCapacity).sum

          TestDateSnapshot.new(
            plan_date: plan_date,
            mom_id: mom.id,
            is_closed: is_closed,
            free_capacity: free_capacity,
          )
        end
      end
    end
  end
end