Fcmpush.configure do |config|
  config.json_key_io = Struct.new(:read).new(Rails.application.config.x.firebase.credentials_json) # See https://github.com/miyataka/fcmpush/issues/19
  config.server_key = Rails.application.config.x.firebase.server_key
end
