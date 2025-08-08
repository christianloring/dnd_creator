class CampaignCharacter < ApplicationRecord
  belongs_to :campaign
  belongs_to :character

  validates :campaign_id, uniqueness: { scope: :character_id }
end
