require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { should have_many(:characters).dependent(:destroy) }
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:campaigns).dependent(:destroy) }
    it { should have_many(:notes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email_address) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(user).to be_valid
    end
  end

  describe 'email normalization' do
    it 'downcases email before save' do
      user.email_address = 'USER@EXAMPLE.COM'
      user.save!
      expect(user.email_address).to eq('user@example.com')
    end
  end
end
