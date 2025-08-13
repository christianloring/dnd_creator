FactoryBot.define do
  factory :character_feat do
    association :character
    association :feat
  end
end
