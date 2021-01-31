class UserVaccinationFlow
  include ActiveModel::Model

  attr_accessor :action
  attr_accessor :user_id
  attr_accessor :region_id
  attr_accessor :county_id

  def self.from_message(message)
    json_payload = case message
                   when Facebook::Messenger::Incoming::Message then
                     message.quick_reply
                   when Facebook::Messenger::Incoming::Postback then
                     message.payload
                   else
                     nil
                   end || '{}'
    json = JSON
             .parse(json_payload)
             .symbolize_keys
             .merge(user_id: message.sender['id'])

    UserVaccinationFlow.new(json)
  end

  def region
    @region ||= Region.find_signed(region_id)
  end

  def with(**attributes)
    self.class.new(as_json.merge(attributes).stringify_keys)
  end

  def as_json(options = {})
    super(options.reverse_merge(except: 'region'))
  end
end