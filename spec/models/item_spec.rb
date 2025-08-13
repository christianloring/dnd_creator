require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should have_many(:character_items) }
    it { should have_many(:characters).through(:character_items) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:item)).to be_valid
    end
  end
end
