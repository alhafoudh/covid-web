module Testing
  module Api
    class MomsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @moms = Mom.order(title: :asc)

        fresh_when(@moms, public: true)
        expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
      end
    end
  end
end