FactoryBot.define do
  factory :test_date do
    sequence(:date) do |n|
      Date.today + n
    end
  end

  factory :vaccination_date do
    sequence(:date) do |n|
      Date.today + n
    end
  end
end