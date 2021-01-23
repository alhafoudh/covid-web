module Testing
  class DashboardController < ApplicationController
    helper_method :moms_for

    def index
      request.session_options[:skip] = true

      @update_interval = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL', 15).to_i

      @test_dates = TestDate
                      .where('date >= ? AND date <= ?', Date.today, Date.today + num_test_days)
                      .order(date: :asc)

      @regions = Region
                   .includes(
                     counties: {
                       moms: [
                         :region,
                         :county,
                         {
                           latest_test_date_snapshots: {
                             test_date_snapshot: [:test_date]
                           }
                         }
                       ]
                     }
                   )
                   .order(name: :asc)

      moms = RychlejsieMom
               .includes(
                 :region, :county,
                 latest_test_date_snapshots: { test_date_snapshot: [:test_date] })
               .order(title: :asc)

      @default_make_reservation_url = ENV.fetch('MAKE_RESERVATION_URL', '#')

      if stale?(moms, public: true)
        @moms_by_county = moms
                            .group_by(&:county)
      end
      expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
    end

    private

    def moms_for(county)
      @moms_by_county.fetch(county, [])
    end

    def num_test_days
      ENV.fetch('NUM_TEST_DAYS', 10).to_i
    end
  end
end