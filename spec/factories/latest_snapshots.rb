FactoryBot.define do
  factory :latest_test_date_snapshot do
    association :place, factory: :mom
    association :plan_date, factory: :test_date
    snapshot { association :test_date_snapshot, place: instance.place, plan_date: instance.plan_date }
    previous_snapshot { association :test_date_snapshot, place: instance.place, plan_date: instance.plan_date }
    enabled { true }
  end

  factory :latest_vaccination_date_snapshot do
    association :place, factory: :vacc
    association :plan_date, factory: :vaccination_date
    snapshot { association :vaccination_date_snapshot, place: instance.place, plan_date: instance.plan_date }
    previous_snapshot { association :vaccination_date_snapshot, place: instance.place, plan_date: instance.plan_date }
    enabled { true }
  end
end