require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:game_profile) { create(:game_profile) }
  let(:run) { build(:run, game_profile: game_profile) }

  describe 'associations' do
    it { should belong_to(:game_profile) }
  end

  describe 'validations' do
    it { should validate_presence_of(:stage) }
    it { should validate_numericality_of(:stage).is_greater_than(0) }

    it { should validate_presence_of(:result) }
    it { should validate_inclusion_of(:result).in_array(%w[win lose]) }

    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    describe 'before_validation :set_defaults' do
      context 'on create' do
        let(:run) { Run.new(game_profile: game_profile, stage: 1, result: 'win', score: 100) }

        it 'sets default data hash' do
          run.valid?
          expect(run.data).to eq({})
        end
      end
    end
  end

  describe 'class methods' do
    describe '.create_from_game_state' do
      let(:game_profile) { create(:game_profile, level: 3, exp: 15, hp_current: 20, gold: 150, data: { gear: { armor: 2 } }) }

      it 'creates a run with game state data' do
        run = Run.create_from_game_state(game_profile, 5, 'win', 250)

        expect(run.game_profile).to eq(game_profile)
        expect(run.stage).to eq(5)
        expect(run.result).to eq('win')
        expect(run.score).to eq(250)
        expect(run.data).to include(
          'final_level' => 3,
          'final_exp' => 15,
          'final_hp' => 20,
          'final_gold' => 150,
          'game_data' => { 'gear' => { 'armor' => 2 } }
        )
      end

      it 'raises error for invalid data' do
        expect {
          Run.create_from_game_state(game_profile, 0, 'invalid', -1)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(run).to be_valid
    end
  end
end
