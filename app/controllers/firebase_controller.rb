class FirebaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def configuration
    expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
  end
end
