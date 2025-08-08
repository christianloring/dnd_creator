class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_characters, dependent: :destroy
  has_many :characters, through: :campaign_characters

  validates :name, presence: true
  validates :description, presence: true
end
