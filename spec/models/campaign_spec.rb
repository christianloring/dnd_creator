require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:campaign_characters).dependent(:destroy) }
    it { should have_many(:characters).through(:campaign_characters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:campaign)).to be_valid
    end
  end

  describe 'with characters' do
    let(:campaign) { create(:campaign) }
    let(:character1) { create(:character, user: campaign.user) }
    let(:character2) { create(:character, user: campaign.user) }

    it 'can have multiple characters' do
      campaign.characters << character1
      campaign.characters << character2

      expect(campaign.characters.count).to eq(2)
      expect(campaign.characters).to include(character1, character2)
    end
  end
end
