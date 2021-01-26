module Testing
  module Api
    class LatestTestDateSnapshotsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @latest_test_date_snapshots = LatestTestDateSnapshot
                                        .joins(:test_date)
                                        .order('test_dates.date': :asc)

        fresh_when(@latest_test_date_snapshots, public: true)
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end
  end
end