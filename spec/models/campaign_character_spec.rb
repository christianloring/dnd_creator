require 'rails_helper'

RSpec.describe CampaignCharacter, type: :model do
  describe 'associations' do
    it { should belong_to(:campaign) }
    it { should belong_to(:character) }
  end

  describe 'validations' do
    subject { build(:campaign_character) }
    it { should validate_uniqueness_of(:campaign_id).scoped_to(:character_id) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:campaign_character)).to be_valid
    end
  end
end
