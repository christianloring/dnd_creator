require 'rails_helper'

RSpec.describe Character, type: :model do
  let(:user) { create(:user) }
  let(:character) { build(:character, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:character_feats).dependent(:destroy) }
    it { should have_many(:feats).through(:character_feats) }
    it { should have_many(:character_items).dependent(:destroy) }
    it { should have_many(:items).through(:character_items) }
    it { should have_many(:campaign_characters).dependent(:destroy) }
    it { should have_many(:campaigns).through(:campaign_characters) }
    it { should have_many(:notes).dependent(:destroy) }
    it { should have_one(:game_profile).dependent(:destroy) }
    it { should have_one_attached(:profile_picture) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:character_class).in_array(Character::FANTASY_CLASSES) }

    describe 'subclass validation' do
      context 'when character_class is Warrior' do
        subject { build(:character, user: user, character_class: 'Warrior', subclass: 'Path of the Berserker') }
        it { should be_valid }
      end

      context 'when subclass is not valid for character_class' do
        subject { build(:character, user: user, character_class: 'Warrior', subclass: 'Invalid Subclass') }
        it { should_not be_valid }
      end

      context 'when subclass is blank' do
        subject { build(:character, user: user, character_class: 'Warrior', subclass: '') }
        it { should be_valid }
      end
    end
  end

  describe 'constants' do
    it 'defines FANTASY_CLASSES' do
      expect(Character::FANTASY_CLASSES).to include('Warrior', 'Wizard', 'Mage')
    end

    it 'defines SUBCLASSES_BY_CLASS' do
      expect(Character::SUBCLASSES_BY_CLASS['Warrior']).to include('Path of the Berserker')
      expect(Character::SUBCLASSES_BY_CLASS['Wizard']).to include('School of Evocation')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(character).to be_valid
    end
  end
end
