require 'rails_helper'

RSpec.describe CharacterItem, type: :model do
  describe 'associations' do
    it { should belong_to(:character) }
    it { should belong_to(:item) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:character_item)).to be_valid
    end
  end
end
