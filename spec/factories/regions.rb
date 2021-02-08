FactoryBot.define do
  factory :region do
    sequence(:name) do |n|
      "Region #{n}"
    end
    sequence(:external_id) do |n|
      "region_#{n}"
    end
  end
end