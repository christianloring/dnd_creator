FactoryBot.define do
  factory :campaign do
    sequence(:name) { |n| "Campaign #{n}" }
    description { "An epic D&D campaign filled with adventure and mystery." }
    association :user
  end
end
