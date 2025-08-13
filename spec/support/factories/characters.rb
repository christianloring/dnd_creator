FactoryBot.define do
  factory :character do
    association :user
    name { "Arannis" }
    character_class { "Wizard" }
    subclass { "School of Evocation" }
    species { "Elf" }
    level { 1 }
    strength { rand(8..20) }
    dexterity { rand(8..20) }
    constitution { rand(8..20) }
    intelligence { rand(8..20) }
    wisdom { rand(8..20) }
    charisma { rand(8..20) }

    trait :warrior do
      character_class { "Warrior" }
      subclass { "Path of the Berserker" }
    end

    trait :mage do
      character_class { "Mage" }
      subclass { "College of Lore" }
    end

    trait :guardian do
      character_class { "Guardian" }
      subclass { "Life Domain" }
    end

    trait :mystic do
      character_class { "Mystic" }
      subclass { "Circle of Nature" }
    end

    trait :scout do
      character_class { "Scout" }
      subclass { "Pathfinder" }
    end

    trait :rogue do
      character_class { "Rogue" }
      subclass { "Thief" }
    end

    trait :sage do
      character_class { "Sage" }
      subclass { "School of Knowledge" }
    end

    trait :ranger do
      character_class { "Ranger" }
      subclass { "Hunter" }
    end

    trait :warlock do
      character_class { "Warlock" }
      subclass { "Pact of the Fey" }
    end

    trait :wizard do
      character_class { "Wizard" }
      subclass { "School of Evocation" }
    end

    trait :artificer do
      character_class { "Artificer" }
      subclass { "Alchemist" }
    end

    trait :game_profile do
      after(:create) do |character|
        create(:game_profile, character: character)
      end
    end
  end
end
