require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:notable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:note, :for_character)).to be_valid
    end
  end
end
