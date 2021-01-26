module Testing
  class DashboardController < ApplicationController
    def index
      request.session_options[:skip] = true

      @plan_dates = TestDate
                      .where('date >= ? AND date <= ?', Date.today, Date.today + num_test_days)
                      .order(date: :asc)

      @regions = Region
                   .includes(
                     :moms,
                     :counties,
                   )
                   .order(name: :asc)

      places = Mom
                 .enabled
                 .includes(
                   :region, :county,
                   latest_test_date_snapshots: [
                     :test_date,
                     { test_date_snapshot: [:test_date] }
                   ]
                 )
                 .order(title: :asc)

      if stale?(places, public: true)
        @places_by_county = places.group_by(&:county)
      end
      expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
    end

    private

    def num_test_days
      ENV.fetch('NUM_TEST_DAYS', 10).to_i
    end
  end
end