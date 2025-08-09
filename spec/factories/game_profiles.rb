FactoryBot.define do
  factory :game_profile do
    association :character
    level { 1 }
    exp { 0 }
    hp_current { 10 }
    max_hp { 10 }
    gold { 0 }
    data { {} }
  end
end
