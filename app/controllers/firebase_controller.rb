class FirebaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def service_worker
    expires_in 1.minute
  end
end
