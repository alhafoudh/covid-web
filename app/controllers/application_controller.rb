class ApplicationController < ActionController::Base
  protected

  def cached_content_expires_in
    ENV.fetch('CACHED_CONTENT_EXPIRATION_MINUTES', 15).to_i.minutes
  end

  def cached_content_allowed_stale
    ENV.fetch('CACHED_CONTENT_STALE_MINUTES', 1).to_i.minutes
  end
end
