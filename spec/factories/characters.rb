FactoryBot.define do
  factory :character do
    user { nil }
    name { "MyString" }
    character_class { "MyString" }
    subclass { "MyString" }
    species { "MyString" }
    level { 1 }
    strength { 1 }
    dexterity { 1 }
    constitution { 1 }
    intelligence { 1 }
    wisdom { 1 }
    charisma { 1 }
  end
end
