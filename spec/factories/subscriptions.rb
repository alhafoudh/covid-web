FactoryBot.define do
  factory :vaccination_subscription do
    channel { 'webpush' }
    sequence(:user_id) do |n|
      "user_#{n}"
    end
    association :region
  end
end