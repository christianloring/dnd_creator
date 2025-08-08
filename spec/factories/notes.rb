FactoryBot.define do
  factory :note do
    association :user

    trait :for_character do
      association :notable, factory: :character
    end

    trait :for_campaign do
      association :notable, factory: :campaign
    end

    title { "MyString" }
    body  { "MyText" }
  end
end
