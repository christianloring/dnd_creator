require 'rails_helper'

RSpec.describe EncounterRules2024 do
  let(:rules) { described_class.new }

  describe '#xp_budget' do
    it 'calculates XP budget for party' do
      budget = rules.xp_budget(party_level: 5, party_size: 4, difficulty: :hard)
      expect(budget).to eq(4400) # 1100 * 4
    end

    it 'handles different difficulties' do
      easy_budget = rules.xp_budget(party_level: 5, party_size: 4, difficulty: :easy)
      medium_budget = rules.xp_budget(party_level: 5, party_size: 4, difficulty: :medium)
      hard_budget = rules.xp_budget(party_level: 5, party_size: 4, difficulty: :hard)

      expect(easy_budget).to eq(2000) # 500 * 4
      expect(medium_budget).to eq(3000) # 750 * 4
      expect(hard_budget).to eq(4400) # 1100 * 4
    end

    it 'handles different party sizes' do
      budget_2 = rules.xp_budget(party_level: 5, party_size: 2, difficulty: :hard)
      budget_6 = rules.xp_budget(party_level: 5, party_size: 6, difficulty: :hard)

      expect(budget_2).to eq(2200) # 1100 * 2
      expect(budget_6).to eq(6600) # 1100 * 6
    end

    it 'handles different party levels' do
      level_1_budget = rules.xp_budget(party_level: 1, party_size: 4, difficulty: :hard)
      level_20_budget = rules.xp_budget(party_level: 20, party_size: 4, difficulty: :hard)

      expect(level_1_budget).to eq(400) # 100 * 4
      expect(level_20_budget).to eq(88000) # 22000 * 4
    end

    it 'raises error for invalid party level' do
      expect {
        rules.xp_budget(party_level: 25, party_size: 4, difficulty: :hard)
      }.to raise_error(KeyError)
    end

    it 'raises error for invalid difficulty' do
      expect {
        rules.xp_budget(party_level: 5, party_size: 4, difficulty: :invalid)
      }.to raise_error(KeyError)
    end
  end

  describe '#pick_solo_boss' do
    let(:repository) { instance_double(MonsterRepository) }
    let(:test_monster) do
      MonsterRepository::Monster.new(
        name: "Test Boss",
        cr: "10",
        xp_value: 5900,
        tags: %w[beast]
      )
    end

    it 'suggests solo boss for party' do
      allow(repository).to receive(:best_boss_for).with(4400, theme: nil).and_return(test_monster)

      boss = rules.pick_solo_boss(
        party_level: 5,
        party_size: 4,
        theme: nil,
        repository: repository
      )

      expect(boss).to eq(test_monster)
    end

    it 'passes theme to repository' do
      allow(repository).to receive(:best_boss_for).with(4400, theme: 'undead').and_return(test_monster)

      boss = rules.pick_solo_boss(
        party_level: 5,
        party_size: 4,
        theme: 'undead',
        repository: repository
      )

      expect(boss).to eq(test_monster)
    end
  end

  describe '#pick_minion' do
    let(:repository) { instance_double(MonsterRepository) }
    let(:test_monster) do
      MonsterRepository::Monster.new(
        name: "Test Minion",
        cr: "2",
        xp_value: 450,
        tags: %w[beast]
      )
    end

    it 'suggests minion for party' do
      allow(repository).to receive(:good_minion_for).with(3000, theme: nil).and_return(test_monster)

      minion = rules.pick_minion(
        party_level: 5,
        party_size: 4,
        theme: nil,
        repository: repository
      )

      expect(minion).to eq(test_monster)
    end

    it 'passes theme to repository' do
      allow(repository).to receive(:good_minion_for).with(3000, theme: 'flying').and_return(test_monster)

      minion = rules.pick_minion(
        party_level: 5,
        party_size: 4,
        theme: 'flying',
        repository: repository
      )

      expect(minion).to eq(test_monster)
    end
  end

  describe 'XP_BY_LEVEL_AND_DIFFICULTY' do
    it 'has data for levels 1-20' do
      expect(described_class::XP_BY_LEVEL_AND_DIFFICULTY.keys).to contain_exactly(
        *1.upto(20).to_a
      )
    end

    it 'has easy, medium, and hard difficulties for each level' do
      described_class::XP_BY_LEVEL_AND_DIFFICULTY.each do |level, difficulties|
        expect(difficulties.keys).to contain_exactly(:easy, :medium, :hard)
      end
    end

    it 'has increasing XP values for higher levels' do
      level_1_hard = described_class::XP_BY_LEVEL_AND_DIFFICULTY[1][:hard]
      level_20_hard = described_class::XP_BY_LEVEL_AND_DIFFICULTY[20][:hard]

      expect(level_20_hard).to be > level_1_hard
    end

    it 'has increasing XP values for higher difficulties' do
      level_5_easy = described_class::XP_BY_LEVEL_AND_DIFFICULTY[5][:easy]
      level_5_medium = described_class::XP_BY_LEVEL_AND_DIFFICULTY[5][:medium]
      level_5_hard = described_class::XP_BY_LEVEL_AND_DIFFICULTY[5][:hard]

      expect(level_5_hard).to be > level_5_medium
      expect(level_5_medium).to be > level_5_easy
    end
  end
end
