class ApplicationController < ActionController::Base
  def crash
    raise 'Crash!'
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
