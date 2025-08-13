FactoryBot.define do
  factory :npc do
    association :user
    name { "Test NPC" }
    data { {
      "body_types" => "Average height",
      "build" => "Athletic",
      "skintone" => "Fair",
      "temperament" => "Calm and collected",
      "voice" => "Deep"
    } }
  end
end
