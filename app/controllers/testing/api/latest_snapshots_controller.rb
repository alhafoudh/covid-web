module Testing
  module Api
    class LatestSnapshotsController < ApplicationController
      def index
        request.session_options[:skip] = true

        @latest_snapshots = LatestTestDateSnapshot
                                        .joins(:plan_date)
                                        .order('plan_dates.date': :asc)

        fresh_when(@latest_snapshots, public: true)
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end
  end
end