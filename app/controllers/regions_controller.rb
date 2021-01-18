class RegionsController < ApplicationController
  def index
    @regions = Region
                 .joins(:counties)
                 .includes(:counties)
                 .order(name: :asc, 'counties.name': :asc)

    fresh_when(@regions, public: true)
  end
end
