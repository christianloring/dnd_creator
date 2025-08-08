FactoryBot.define do
  factory :character do
    association :user
    name { "Arannis" }
    character_class { "Wizard" }
    subclass { "Evocation" }
    species { "Elf" }
    level { 1 }
    strength { rand(8..20) }
    dexterity { rand(8..20) }
    constitution { rand(8..20) }
    intelligence { rand(8..20) }
    wisdom { rand(8..20) }
    charisma { rand(8..20) }
  end
end
