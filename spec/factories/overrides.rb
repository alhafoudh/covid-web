FactoryBot.define do
  factory :override do
    matches { [] }
    replacements { [] }
  end

  factory :place_override, parent: :override, class: 'PlaceOverride' do
  end
end