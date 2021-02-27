module Testing
  module Rychlejsie
    class UpdateMomSnapshots < ApplicationJob
      include UpdatesSnapshots

      attr_reader :mom, :snapshots_data, :plan_dates

      def perform(mom:, snapshots_data:, plan_dates:)
        @mom = mom
        @snapshots_data = snapshots_data
        @plan_dates = plan_dates

        ActiveRecord::Base.transaction do
          logger.info "Updating Rychlejsie test date snapshots for mom ##{mom.id}"

          prepare_snapshots!
          created_snapshots = create_snapshots!(snapshots)
          update_latest_snapshots!(created_snapshots)
        end
      end

      private

      attr_reader :snapshots

      def prepare_snapshots!
        limit_per_hour = mom.external_details.fetch('limitPer1HourSlot', 0).to_i
        free_capacity_by_date = snapshots_data
                                  .reduce({}) do |acc, hour|
          date = Time.zone.parse(hour[:time]).to_date
          registrations = hour[:registrations].to_i
          acc[date] ||= 0
          free_capacity = limit_per_hour - registrations
          acc[date] += free_capacity if free_capacity > 0
          acc
        end

        @snapshots = free_capacity_by_date.map do |date, free_capacity|
          plan_date = plan_dates.find do |plan_date|
            plan_date.date == date
          end
          unless plan_date.present?
            plan_date = TestDate.find_or_create_by!(
              date: date,
            )
          end

          is_closed = false
          free_capacity = free_capacity

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