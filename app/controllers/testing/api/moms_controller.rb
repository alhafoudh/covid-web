module Testing
  module Api
    class MomsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @moms = Mom
                  .includes(:region, :county)
                  .order(title: :asc)

        fresh_when(@moms, public: true)
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end
  end
end