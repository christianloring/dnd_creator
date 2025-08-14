require 'rails_helper'

RSpec.describe EncounterBuilder do
  let(:monster_repo) { instance_double(MonsterRepository) }
  let(:rules) { instance_double(EncounterRules2024) }
  let(:builder) { described_class.new(monster_repo: monster_repo, rules: rules) }

  let(:test_monster) do
    MonsterRepository::Monster.new(
      name: "Test Monster",
      cr: "5",
      xp_value: 1800,
      tags: %w[beast]
    )
  end

  let(:encounter_request) do
    EncounterRequest.new(
      party_level: 5,
      party_size: 4,
      shape: "solo_boss",
      difficulty: "hard",
      theme: nil
    )
  end

  describe '#call' do
    before do
      allow(rules).to receive(:xp_budget).and_return(4400) # 1100 * 4 for hard difficulty
    end

    context 'with solo_boss shape' do
      it 'creates solo boss encounter' do
        allow(monster_repo).to receive(:best_boss_for).with(4400, theme: nil).and_return(test_monster)

        result = builder.call(encounter_request)

        expect(result.total_xp_budget).to eq(4400)
        expect(result.monsters.length).to eq(1)
        expect(result.monsters.first.name).to eq('Test Monster')
        expect(result.monsters.first.count).to eq(1)
        expect(result.monsters.first.xp_total).to eq(1800)
      end

      it 'returns empty monsters when no boss fits budget' do
        allow(monster_repo).to receive(:best_boss_for).with(4400, theme: nil).and_return(nil)

        result = builder.call(encounter_request)

        expect(result.monsters).to be_empty
      end
    end

    context 'with two_bosses shape' do
      let(:encounter_request) do
        EncounterRequest.new(
          party_level: 5,
          party_size: 4,
          shape: "two_bosses",
          difficulty: "hard",
          theme: nil
        )
      end

      it 'creates double boss encounter' do
        allow(monster_repo).to receive(:best_boss_for).with(2420, theme: nil).and_return(test_monster)

        result = builder.call(encounter_request)

        expect(result.monsters.length).to eq(2)
        expect(result.monsters.first.name).to eq('Test Monster')
        expect(result.monsters.first.count).to eq(1)
      end
    end

    context 'with boss_minions shape' do
      let(:encounter_request) do
        EncounterRequest.new(
          party_level: 5,
          party_size: 4,
          shape: "boss_minions",
          difficulty: "hard",
          theme: nil
        )
      end

      let(:minion_monster) do
        MonsterRepository::Monster.new(
          name: "Minion Monster",
          cr: "1",
          xp_value: 200,
          tags: %w[beast]
        )
      end

      it 'creates boss with minions encounter' do
        # Budget: 4400
        # Boss budget: 4400 * 0.6 = 2640
        # Minion budget: 4400 - 1800 = 2600
        allow(monster_repo).to receive(:best_boss_for).with(2640, theme: nil).and_return(test_monster)
        allow(monster_repo).to receive(:good_minion_for).with(2600, theme: nil).and_return(minion_monster)

        result = builder.call(encounter_request)

        expect(result.monsters.length).to eq(2)
        expect(result.monsters.first.name).to eq('Test Monster')
        expect(result.monsters.first.count).to eq(1)
        expect(result.monsters.last.name).to eq('Minion Monster')
        expect(result.monsters.last.count).to eq(6) # 2600 / 200 = 13, capped at 6
      end
    end

    context 'with swarm shape' do
      let(:encounter_request) do
        EncounterRequest.new(
          party_level: 5,
          party_size: 4,
          shape: "swarm",
          difficulty: "hard",
          theme: nil
        )
      end

      it 'creates swarm encounter' do
        allow(monster_repo).to receive(:good_minion_for).with(4400, theme: nil).and_return(test_monster)

        result = builder.call(encounter_request)

        expect(result.monsters.length).to eq(1)
        expect(result.monsters.first.name).to eq('Test Monster')
        expect(result.monsters.first.count).to eq(2) # 4400 / 1800 = 2, capped at 12
      end
    end

    context 'with unknown shape' do
      let(:encounter_request) do
        EncounterRequest.new(
          party_level: 5,
          party_size: 4,
          shape: "unknown",
          difficulty: "hard",
          theme: nil
        )
      end

      it 'returns empty monsters array' do
        result = builder.call(encounter_request)

        expect(result.monsters).to be_empty
      end
    end
  end

  describe 'Result struct' do
    it 'creates result with correct attributes' do
      result = EncounterBuilder::Result.new(
        total_xp_budget: 1000,
        monsters: [],
        notes: [ 'Test note' ]
      )

      expect(result.total_xp_budget).to eq(1000)
      expect(result.monsters).to eq([])
      expect(result.notes).to eq([ 'Test note' ])
    end
  end

  describe 'MonsterPick struct' do
    it 'creates monster pick with correct attributes' do
      pick = EncounterBuilder::MonsterPick.new(
        name: 'Test Monster',
        cr: '5',
        count: 3,
        tags: %w[beast],
        xp_each: 1800,
        xp_total: 5400
      )

      expect(pick.name).to eq('Test Monster')
      expect(pick.cr).to eq('5')
      expect(pick.count).to eq(3)
      expect(pick.tags).to eq(%w[beast])
      expect(pick.xp_each).to eq(1800)
      expect(pick.xp_total).to eq(5400)
    end
  end
end
