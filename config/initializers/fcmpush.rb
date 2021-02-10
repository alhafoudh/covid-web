Fcmpush.configure do |config|
  config.json_key_io = StringIO.new(Rails.application.config.x.firebase.credentials_json)
  config.server_key = Rails.application.config.x.firebase.server_key
end
