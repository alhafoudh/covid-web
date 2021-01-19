class RegionsController < ApplicationController
  def index
    request.session_options[:skip] = true

    @regions = Region
                 .joins(:counties)
                 .includes(:counties)
                 .order(name: :asc, 'counties.name': :asc)

    fresh_when(@regions, public: true)
    expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
  end
end
