FactoryBot.define do
  factory :test_date_snapshot do
    association :place, factory: :mom
    association :plan_date, factory: :test_date
    is_closed { false }
    free_capacity { 0 }
  end

  factory :vaccination_date_snapshot do
    association :place, factory: :vacc
    association :plan_date, factory: :vaccination_date
    is_closed { false }
    free_capacity { 0 }
  end
end