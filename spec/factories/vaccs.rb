FactoryBot.define do
  factory :vacc, class: 'Vacc' do
    title { 'Some Vacc' }
    longitude { 47.0 }
    latitude { 16.0 }
    street_name { 'Road' }
    street_number { '4' }
    postal_code { '1234' }
    association :region
    association :county
    reservations_url { 'http://example.com' }
    sequence(:external_id) do |n|
      "vacc_#{n}"
    end
    enabled { true }
  end

  factory :nczi_vacc, parent: :vacc, class: 'NcziVacc' do
  end
end