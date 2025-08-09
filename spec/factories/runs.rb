FactoryBot.define do
  factory :run do
    game_profile { nil }
    stage { 1 }
    result { "MyString" }
    score { 1 }
    data { "" }
  end
end
