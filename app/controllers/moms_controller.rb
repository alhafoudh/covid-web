class MomsController < ApplicationController
  def index
    region_id = params[:region_id]
    county_id = params[:county_id]

    @region = Region.find(region_id)
    @county = County.find(county_id)
    @test_dates = TestDate.order(date: :asc)

    @moms = Mom
              .includes(latest_test_date_snapshots: { test_date_snapshot: [:test_date] })
              .where(region_id: region_id, county_id: county_id)
              .order(title: :asc)

    fresh_when etag: @county, last_modified: @county.updated_at, public: true
  end
end
