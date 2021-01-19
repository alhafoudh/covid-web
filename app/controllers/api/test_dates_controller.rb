module Api
  class TestDatesController < ApplicationController
    def index
      request.session_options[:skip] = true

      @test_dates = TestDate.order(date: :asc)

      fresh_when(@test_dates, public: true)
      expires_in(cached_content_expires_in, public: true, stale_while_revalidate: cached_content_allowed_stale)
    end
  end
end