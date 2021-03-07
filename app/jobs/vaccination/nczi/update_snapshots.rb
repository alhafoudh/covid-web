module Vaccination
  module Nczi
    class UpdateSnapshots < ApplicationJob
      include NcziApi
      include RateLimits

      def perform
        ActiveRecord::Base.transaction do
          fetch_all_snapshots!
          update_plan_dates!
          update_snapshots!
        end
      end

      private

      attr_reader :all_snapshots

      def fetch_all_snapshots!
        @all_snapshots = nczi_get_payload("#{base_url}/get_all_drivein_times_vacc")
                           .reduce({}) do |acc, record|
          acc[record['id']] = record.fetch('calendar_data', [])
          acc
        end
      end

      def update_plan_dates!
        UpdatePlanDates.perform_now(snapshots_data: all_snapshots.values.flatten)
      end

      def update_snapshots!
        plan_dates = VaccinationDate.all.to_a

        NcziVacc
          .all
          .enabled
          .includes(
            latest_snapshots: [
              :plan_date,
              { snapshot: [:plan_date] }
            ]
          )
          .find_in_batches(batch_size: 100)
          .map do |vaccs|
          jobs = vaccs.map do |vacc|
            proc do
              UpdateVaccSnapshots.perform_now(
                vacc: vacc,
                snapshots_data: snapshots_data_for(vacc),
                plan_dates: plan_dates,
              )
            end
          end
          process_rate_limited(Rails.application.config.x.vaccination.rate_limit, jobs)
            .flatten
        end
          .flatten
      end

      def snapshots_data_for(vacc)
        all_snapshots.fetch(vacc.external_id, [])
      end
    end
  end
end