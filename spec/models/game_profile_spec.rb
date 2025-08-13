require 'rails_helper'

RSpec.describe GameProfile, type: :model do
  let(:character) { create(:character) }
  let(:game_profile) { build(:game_profile, character: character) }

  describe 'associations' do
    it { should belong_to(:character) }
    it { should have_many(:runs).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:level) }
    it { should validate_numericality_of(:level).is_greater_than(0) }

    it { should validate_presence_of(:exp) }
    it { should validate_numericality_of(:exp).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:hp_current) }
    it { should validate_numericality_of(:hp_current).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:max_hp) }
    it { should validate_numericality_of(:max_hp).is_greater_than(0) }

    it { should validate_presence_of(:gold) }
    it { should validate_numericality_of(:gold).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    describe 'before_validation :set_defaults' do
      context 'on create' do
        let(:character) { create(:character, level: 5, hitpoints: 25) }
        let(:game_profile) { GameProfile.new(character: character) }

        it 'sets default values' do
          game_profile.valid?
          expect(game_profile.level).to eq(5)
          expect(game_profile.exp).to eq(0)
          expect(game_profile.hp_current).to eq(25)
          expect(game_profile.max_hp).to eq(25)
          expect(game_profile.gold).to eq(0)
          expect(game_profile.data).to eq({})
        end
      end
    end
  end

  describe 'instance methods' do
    let(:character) { create(:character, hitpoints: 20) }
    let(:game_profile) { create(:game_profile, character: character, hp_current: 15, max_hp: 20) }

    describe '#base_max_hp' do
      it 'returns character hitpoints' do
        expect(game_profile.base_max_hp).to eq(20)
      end
    end

    describe '#hp_percentage' do
      it 'calculates HP percentage correctly' do
        expect(game_profile.hp_percentage).to eq(75.0)
      end
    end

    describe '#add_exp' do
      it 'adds experience and checks for level up' do
        game_profile.update!(exp: 8, level: 1)
        expect(game_profile.add_exp(2)).to be true # Should level up (10 exp needed)
        expect(game_profile.level).to eq(2)
        expect(game_profile.exp).to eq(0)
      end

      it 'does not level up if not enough exp' do
        game_profile.update!(exp: 5, level: 1)
        expect(game_profile.add_exp(2)).to be false
        expect(game_profile.level).to eq(1)
        expect(game_profile.exp).to eq(7)
      end
    end

    describe '#heal' do
      it 'heals up to max hp' do
        game_profile.heal(10)
        expect(game_profile.hp_current).to eq(20)
      end

      it 'does not exceed max hp' do
        game_profile.heal(100)
        expect(game_profile.hp_current).to eq(20)
      end
    end

    describe '#take_damage' do
      it 'reduces hp but not below 0' do
        game_profile.take_damage(10)
        expect(game_profile.hp_current).to eq(5)
      end

      it 'does not go below 0' do
        game_profile.take_damage(100)
        expect(game_profile.hp_current).to eq(0)
      end
    end

    describe '#add_gold' do
      it 'adds gold' do
        game_profile.add_gold(50)
        expect(game_profile.gold).to eq(50)
      end
    end

    describe '#reset_progress' do
      it 'resets to character base stats' do
        game_profile.update!(level: 5, exp: 100, hp_current: 10, max_hp: 30, gold: 500, data: { test: 'data' })
        game_profile.reset_progress
        expect(game_profile.level).to eq(character.level)
        expect(game_profile.exp).to eq(0)
        expect(game_profile.max_hp).to eq(character.hitpoints)
        expect(game_profile.hp_current).to eq(character.hitpoints)
        expect(game_profile.gold).to eq(0)
        expect(game_profile.data).to eq({})
      end
    end

    describe '#check_level_up' do
      context 'when enough exp to level up' do
        it 'levels up and resets exp' do
          character.update!(level: 1, hitpoints: 20)
          game_profile.update!(level: 1, exp: 10, max_hp: 20, hp_current: 15)
          expect(game_profile.check_level_up).to be true
          expect(game_profile.level).to eq(2)
          expect(game_profile.exp).to eq(0)
          expect(game_profile.max_hp).to eq(28) # 20 + 8
          expect(game_profile.hp_current).to eq(28) # Full heal on level up
        end
      end

      context 'when not enough exp' do
        it 'does not level up' do
          game_profile.update!(level: 1, exp: 5)
          expect(game_profile.check_level_up).to be false
          expect(game_profile.level).to eq(1)
          expect(game_profile.exp).to eq(5)
        end
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(game_profile).to be_valid
    end
  end
end
