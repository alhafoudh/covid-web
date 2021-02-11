class ApplicationController < ActionController::Base
  def crash
    raise 'Crash!'
  end
end
