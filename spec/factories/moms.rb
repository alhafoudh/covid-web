FactoryBot.define do
  factory :mom, class: 'Mom' do
    title { 'Some MOM' }
    longitude { 47.0 }
    latitude { 16.0 }
    street_name { 'Road' }
    street_number { '4' }
    postal_code { '1234' }
    association :region
    association :county
    reservations_url { 'http://example.com' }
    sequence(:external_id) do |n|
      "mom_#{n}"
    end
    external_endpoint { 'http://example.com/external' }
    supports_reservation { true }
    external_details { {} }
    enabled { true }
  end

  factory :nczi_mom, parent: :mom, class: 'NcziMom' do
  end
end