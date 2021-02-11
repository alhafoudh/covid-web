class FirebaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def configuration
    expires_in 1.minute
  end
end
