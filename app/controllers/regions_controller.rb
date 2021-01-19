class RegionsController < ApplicationController
  def index
    request.session_options[:skip] = true

    @regions = Region
                 .joins(:counties)
                 .includes(:counties)
                 .order(name: :asc, 'counties.name': :asc)

    fresh_when(@regions, public: true)
  end
end
