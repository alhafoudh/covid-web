class DashboardController < ApplicationController
  helper_method :moms_for

  def index
    request.session_options[:skip] = true

    @update_interval = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL', 15).to_i

    @test_dates = TestDate
                    .where('date >= ?', Date.today)
                    .order(date: :asc)

    @regions = Region
                 .joins(:counties)
                 .includes(:counties)
                 .order(name: :asc, 'counties.name': :asc)

    @moms = Mom
              .includes(
                :region, :county,
                latest_test_date_snapshots: { test_date_snapshot: [:test_date] })
              .order(title: :asc)

    @default_make_reservation_url = ENV.fetch('MAKE_RESERVATION_URL', '#')

    if stale?(@moms, public: true)
      @moms_by_county = @moms.group_by(&:county)
    end
    expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
  end

  private

  def moms_for(county)
    @moms_by_county.fetch(county, [])
  end
end
