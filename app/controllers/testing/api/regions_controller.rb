module Testing
  module Api
    class RegionsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @regions = Region.order(name: :asc)

        fresh_when(@regions, public: true)
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end
  end
end