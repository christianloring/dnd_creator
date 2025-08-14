FactoryBot.define do
  factory :encounter do
    user
    inputs { { "party_level" => 5, "party_size" => 4, "shape" => "solo_boss", "difficulty" => "hard" } }
    composition { { "total_xp_budget" => 4400, "monsters" => [], "notes" => [] } }
    total_xp { 4400 }
    theme { "beast" }
  end
end
