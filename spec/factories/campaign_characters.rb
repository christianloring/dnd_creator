FactoryBot.define do
  factory :campaign_character do
    association :campaign
    association :character
  end
end
