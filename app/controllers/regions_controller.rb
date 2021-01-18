class RegionsController < ApplicationController
  def index
    @regions = Region
                 .joins(:counties)
                 .includes(:counties)
                 .order(name: :asc, 'counties.name': :asc)
  end
end
