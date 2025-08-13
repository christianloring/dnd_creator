require 'rails_helper'

RSpec.describe CharacterFeat, type: :model do
  describe 'associations' do
    it { should belong_to(:character) }
    it { should belong_to(:feat) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:character_feat)).to be_valid
    end
  end
end
