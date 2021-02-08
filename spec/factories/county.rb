FactoryBot.define do
  factory :county do
    name { 'Here' }
    association :region
    sequence(:external_id) do |n|
      "county_#{n}"
    end
  end
end