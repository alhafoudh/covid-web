module Testing
  module Api
    class PlanDatesController < ApplicationController
      def index
        request.session_options[:skip] = true

        @plan_dates = TestDate.order(date: :asc)

        fresh_when(@plan_dates, public: true)
        expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
      end
    end
  end
end