require 'rails_helper'

RSpec.describe MonsterRepository do
  let(:repository) { described_class.new }
  let(:test_monsters) do
    [
      MonsterRepository::Monster.new(name: "CR 1", cr: "1", xp_value: 200, tags: %w[beast]),
      MonsterRepository::Monster.new(name: "CR 2", cr: "2", xp_value: 450, tags: %w[beast]),
      MonsterRepository::Monster.new(name: "CR 3", cr: "3", xp_value: 700, tags: %w[beast]),
      MonsterRepository::Monster.new(name: "CR 5", cr: "5", xp_value: 1800, tags: %w[beast]),
      MonsterRepository::Monster.new(name: "CR 10", cr: "10", xp_value: 5900, tags: %w[beast]),
      MonsterRepository::Monster.new(name: "CR 20", cr: "20", xp_value: 25000, tags: %w[beast])
    ]
  end

  before do
    allow(MonsterDataLoader).to receive(:load_monsters).and_return(test_monsters)
  end

  describe '#best_boss_for' do
    it 'returns the highest XP monster within budget' do
      boss = repository.best_boss_for(1000)
      expect(boss.name).to eq('CR 3')
      expect(boss.xp_value).to eq(700)
    end

    it 'returns nil when no monsters fit budget' do
      boss = repository.best_boss_for(50)
      expect(boss).to be_nil
    end

    it 'filters by theme when provided' do
      # Add a monster with different theme
      themed_monsters = test_monsters + [
        MonsterRepository::Monster.new(name: "CR 4 Undead", cr: "4", xp_value: 1100, tags: %w[undead])
      ]
      allow(MonsterDataLoader).to receive(:load_monsters).and_return(themed_monsters)

      boss = repository.best_boss_for(1200, theme: 'undead')
      expect(boss.name).to eq('CR 4 Undead')
    end

    it 'falls back to all monsters when theme has no matches' do
      boss = repository.best_boss_for(1000, theme: 'nonexistent')
      expect(boss.name).to eq('CR 3')
    end
  end

  describe '#good_minion_for' do
    it 'returns monster within half budget' do
      minion = repository.good_minion_for(1000)
      expect(minion.xp_value).to be <= 500
      expect(minion.name).to eq('CR 2')
    end

    it 'returns lowest XP monster when no monsters fit half budget' do
      minion = repository.good_minion_for(100)
      expect(minion.name).to eq('CR 1')
      expect(minion.xp_value).to eq(200)
    end

    it 'filters by theme when provided' do
      themed_monsters = test_monsters + [
        MonsterRepository::Monster.new(name: "CR 1 Flying", cr: "1", xp_value: 200, tags: %w[flying])
      ]
      allow(MonsterDataLoader).to receive(:load_monsters).and_return(themed_monsters)

      minion = repository.good_minion_for(500, theme: 'flying')
      expect(minion.name).to eq('CR 1 Flying')
    end
  end

  describe 'Monster struct' do
    it 'creates monster with correct attributes' do
      monster = MonsterRepository::Monster.new(
        name: "Test Monster",
        cr: "5",
        xp_value: 1800,
        tags: %w[beast flying]
      )

      expect(monster.name).to eq("Test Monster")
      expect(monster.cr).to eq("5")
      expect(monster.xp_value).to eq(1800)
      expect(monster.tags).to eq(%w[beast flying])
    end
  end
end
