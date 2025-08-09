FactoryBot.define do
  factory :run do
    association :game_profile
    stage { 1 }
    result { "win" }
    score { 100 }
    data { {} }
  end
end
