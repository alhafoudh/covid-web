module Api
  class CountiesController < ApplicationController
    def index
      request.session_options[:skip] = true

      @counties = County.order(name: :asc)

      fresh_when(@counties, public: true)
      expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
    end
  end
end