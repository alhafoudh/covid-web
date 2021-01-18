class MomsController < ApplicationController
  def index
    region_id = params[:region_id]
    county_id = params[:county_id]

    @region = Region.find(region_id)
    @county = County.find(county_id)

    @moms = Mom.where(region_id: region_id, county_id: county_id).order(title: :asc)
  end
end
