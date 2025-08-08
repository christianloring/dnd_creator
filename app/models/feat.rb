class Feat < ApplicationRecord
  has_many :character_feats
  has_many :characters, through: :character_feats
end
