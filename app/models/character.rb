class Character < ApplicationRecord
  belongs_to :user
  has_many :character_feats, dependent: :destroy
  has_many :feats, through: :character_feats

  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items

  has_one_attached :profile_picture
end
