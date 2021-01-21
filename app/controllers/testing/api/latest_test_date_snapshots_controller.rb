module Testing
  module Api
    class LatestTestDateSnapshotsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @latest_test_date_snapshots = LatestTestDateSnapshot
                                        .joins(:test_date)
                                        .order('test_dates.date': :asc)

        fresh_when(@latest_test_date_snapshots, public: true)
        expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
      end
    end
  end
end