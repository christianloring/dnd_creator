require 'rails_helper'

RSpec.describe Feat, type: :model do
  describe 'associations' do
    it { should have_many(:character_feats) }
    it { should have_many(:characters).through(:character_feats) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:feat)).to be_valid
    end
  end
end
