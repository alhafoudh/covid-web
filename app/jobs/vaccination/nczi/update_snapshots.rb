module Vaccination
  module Nczi
    class UpdateSnapshots < ApplicationJob
      include NcziApi
      include RateLimits

      def perform
        ActiveRecord::Base.transaction do
          plan_dates = VaccinationDate.all.to_a
          jobs = NcziVacc
                   .all
                   .includes(
                     latest_snapshots: [
                       :plan_date,
                       { snapshot: [:plan_date] }
                     ]
                   )
                   .map do |vacc|
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
      end

      private

      def snapshots_data_for(vacc)
        @all_snapshots ||= begin
                             nczi_client
                               .get("#{base_url}/get_all_drivein_times_vacc")
                               .body
                               .fetch('payload', [])
                               .reduce({}) do |acc, record|
                               acc[record['id']] = record.fetch('calendar_data', [])
                               acc
                             end
                           end

        @all_snapshots.fetch(vacc.external_id, [])
      end
    end
  end
end