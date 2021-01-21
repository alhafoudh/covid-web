module Vaccination
  class DashboardController < ApplicationController
    helper_method :vaccs_for

    def index
      request.session_options[:skip] = true

      @update_interval = ENV.fetch('UPDATE_VACCINATION_DATE_SNAPSHOTS_INTERVAL', 15).to_i

      @vaccination_dates = VaccinationDate
                      .where('date >= ? AND date <= ?', Date.today, Date.today + num_vaccination_days)
                      .order(date: :asc)

      @regions = Region
                   .includes(
                     counties: {
                       vaccs: [
                         :region,
                         :county,
                         {
                           latest_vaccination_date_snapshots: {
                             vaccination_date_snapshot: [:vaccination_date]
                           }
                         }
                       ]
                     }
                   )
                   .order(name: :asc)

      vaccs = Vacc
               .includes(
                 :region, :county,
                 latest_vaccination_date_snapshots: { vaccination_date_snapshot: [:vaccination_date] }
               )
               .order(title: :asc)

      @default_make_reservation_url = ENV.fetch('MAKE_RESERVATION_URL', '#')

      if stale?(vaccs, public: true)
        @vaccs_by_county = vaccs
                            .group_by(&:county)
      end
      expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
    end

    private

    def vaccs_for(county)
      @vaccs_by_county.fetch(county, [])
    end

    def num_vaccination_days
      ENV.fetch('NUM_VACCINATION_DAYS', 10).to_i
    end
  end
end