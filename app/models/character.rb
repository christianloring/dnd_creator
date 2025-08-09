class Character < ApplicationRecord
  DND_CLASSES = %w[
    Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue
    Sorcerer Warlock Wizard Artificer
  ].freeze

    SUBCLASSES_BY_CLASS = {
    "Barbarian" => [ "Path of the Berserker", "Path of the Wild Heart" ],
    "Bard" => [ "College of Dance", "College of Lore", "College of Valor" ],
    "Cleric" => [ "Life Domain", "Light Domain", "Trickery Domain" ],
    "Druid" => [ "Circle of the Land", "Circle of the Moon", "Circle of the Sea" ],
    "Fighter" => [ "Champion", "Battle Master", "Eldritch Knight" ],
    "Monk" => [ "Warrior of the Hand", "Warrior of the Shadow", "Warrior of the Elements" ],
    "Paladin" => [ "Oath of Devotion", "Oath of Vengeance", "Oath of the Ancients" ],
    "Ranger" => [ "Hunter", "Beast Master", "Gloom Stalker" ],
    "Rogue" => [ "Thief", "Assassin", "Arcane Trickster" ],
    "Sorcerer" => [ "Draconic Bloodline", "Wild Magic", "Aberrant Mind" ],
    "Warlock" => [ "The Archfey", "The Fiend", "The Great Old One" ],
    "Wizard" => [ "Evocation", "Illusion", "Divination" ],
    "Artificer" => [ "Alchemist", "Artillerist", "Battle Smith" ]
  }.freeze

  belongs_to :user
  has_many :character_feats, dependent: :destroy
  has_many :feats, through: :character_feats

  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items

  has_many :campaign_characters, dependent: :destroy
  has_many :campaigns, through: :campaign_characters
  has_many :notes, as: :notable, dependent: :destroy

  has_one :game_profile, dependent: :destroy

  has_one_attached :profile_picture

  validates :character_class, inclusion: { in: DND_CLASSES }
  validates :subclass, inclusion: { in: ->(character) { SUBCLASSES_BY_CLASS[character.character_class] || [] }, allow_blank: true }
end
