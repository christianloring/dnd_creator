FactoryBot.define do
  factory :game_profile do
    character { nil }
    level { 1 }
    exp { 1 }
    hp_current { 1 }
    gold { 1 }
    data { "" }
  end
end
