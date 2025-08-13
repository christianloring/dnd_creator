class Character < ApplicationRecord
  FANTASY_CLASSES = %w[
    Warrior Mage Scout Guardian Mystic Ranger Rogue Sage Warlock Wizard Artificer
  ].freeze

  SUBCLASSES_BY_CLASS = {
    "Warrior" => [ "Path of the Berserker", "Path of the Guardian", "Path of the Champion" ],
    "Mage" => [ "College of Lore", "College of Battle", "College of Elements" ],
    "Guardian" => [ "Life Domain", "Protection Domain", "Justice Domain" ],
    "Mystic" => [ "Circle of Nature", "Circle of Spirits", "Circle of Elements" ],
    "Scout" => [ "Pathfinder", "Beast Master", "Shadow Walker" ],
    "Rogue" => [ "Thief", "Assassin", "Trickster" ],
    "Sage" => [ "School of Knowledge", "School of Divination", "School of Illusion" ],
    "Ranger" => [ "Hunter", "Beast Companion", "Wilderness Guide" ],
    "Warlock" => [ "Pact of the Fey", "Pact of the Void", "Pact of the Elements" ],
    "Wizard" => [ "School of Evocation", "School of Abjuration", "School of Conjuration" ],
    "Artificer" => [ "Alchemist", "Engineer", "Enchanter" ]
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

  validates :character_class, inclusion: { in: FANTASY_CLASSES }
  validates :subclass, inclusion: { in: ->(character) { SUBCLASSES_BY_CLASS[character.character_class] || [] }, allow_blank: true }
end
