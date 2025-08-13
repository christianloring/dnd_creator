FactoryBot.define do
  factory :character_item do
    association :character
    association :item
  end
end
