require 'rails_helper'

RSpec.describe MonsterDataLoader do
  describe '.load_monsters' do
    let(:fixture_path) { Rails.root.join('config', 'fixtures', 'monsters.yml') }

    before do
      # Create a temporary fixture file for testing
      FileUtils.mkdir_p(File.dirname(fixture_path))
      File.write(fixture_path, test_fixture_data)
    end

    after do
      File.delete(fixture_path) if File.exist?(fixture_path)
    end

    it 'loads monsters from fixture file' do
      monsters = described_class.load_monsters

      expect(monsters).to be_an(Array)
      expect(monsters.length).to eq(2)

      first_monster = monsters.first
      expect(first_monster).to be_a(MonsterRepository::Monster)
      expect(first_monster.name).to eq('Test Monster 1')
      expect(first_monster.cr).to eq('1')
      expect(first_monster.xp_value).to eq(200)
      expect(first_monster.tags).to eq([ 'beast' ])
    end

    it 'returns empty array when fixture file does not exist' do
      File.delete(fixture_path)

      monsters = described_class.load_monsters
      expect(monsters).to eq([])
    end

    it 'handles malformed YAML gracefully' do
      File.write(fixture_path, 'invalid: yaml: content:')

      expect { described_class.load_monsters }.not_to raise_error
    end

    private

    def test_fixture_data
      <<~YAML
        test_monster_1:
          name: "Test Monster 1"
          cr: "1"
          xp_value: 200
          tags: ["beast"]

        test_monster_2:
          name: "Test Monster 2"
          cr: "2"
          xp_value: 450
          tags: ["beast", "flying"]
      YAML
    end
  end
end
