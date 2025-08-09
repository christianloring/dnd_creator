class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_characters, dependent: :destroy
  has_many :characters, through: :campaign_characters
  has_many :notes, as: :notable, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
