FactoryBot.define do
  factory :override do
    sequence(:name) do |n|
      "Override ##{n}"
    end
    matches { [] }
    replacements { [] }
  end

  factory :place_override, parent: :override, class: 'PlaceOverride' do
  end
end