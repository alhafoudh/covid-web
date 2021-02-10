module Vaccination
  class DashboardController < ApplicationController
    def index
      request.session_options[:skip] = true

      @plan_dates = VaccinationDate
                      .where('date >= ? AND date <= ?', Date.today, Date.today + num_vaccination_days)
                      .order(date: :asc)

      @regions = Region
                   .includes(
                     :vaccs,
                     :counties,
                   )
                   .order(name: :asc)

      places = Vacc
                 .enabled
                 .includes(
                   :region, :county,
                   latest_snapshots: [
                     :plan_date,
                     { snapshot: [:plan_date] }
                   ]
                 )
                 .order(title: :asc)

      if stale?(places, public: true)
        @places_by_county = places.group_by(&:county)
      end

      if Rails.env.production?
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end

    private

    def num_vaccination_days
      ENV.fetch('NUM_VACCINATION_DAYS', 10).to_i
    end
  end
end