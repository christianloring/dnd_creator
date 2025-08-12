require 'rails_helper'

RSpec.describe Npc, type: :model do
  let(:user) { create(:user) }
  let(:npc) { build(:npc, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(npc).to be_valid
    end
  end

  describe 'class methods' do
    describe '.randomize' do
      it 'creates a new NPC with random data' do
        random_npc = Npc.randomize
        expect(random_npc).to be_a(Npc)
        expect(random_npc.name).to be_present
        expect(random_npc.data).to be_a(Hash)
      end
    end

    describe '.generate_random_name' do
      it 'generates a random name' do
        name = Npc.generate_random_name
        expect(name).to match(/\A\w+ \w+\z/)
      end
    end

    describe '.generate_random_data' do
      it 'generates random data for all categories' do
        data = Npc.generate_random_data
        expect(data).to be_a(Hash)
        expect(data.keys).to match_array(Npc::CATEGORIES.keys.map(&:to_s))
      end
    end
  end

  describe 'instance methods' do
    describe '#display_traits' do
      it 'returns formatted traits' do
        npc.data = { 'body_types' => 'Tall', 'temperament' => 'Calm' }
        traits = npc.display_traits
        expect(traits).to include('Body types: Tall')
        expect(traits).to include('Temperament: Calm')
      end

      it 'excludes None values' do
        npc.data = { 'body_types' => 'Tall', 'temperament' => 'None' }
        traits = npc.display_traits
        expect(traits).to include('Body types: Tall')
        expect(traits).not_to include('Temperament: None')
      end
    end

    describe '#description' do
      it 'generates a readable description' do
        npc.data = {
          'body_types' => 'Tall',
          'build' => 'Athletic',
          'skintone' => 'Fair',
          'eye_color' => 'Blue',
          'temperament' => 'Calm'
        }
        description = npc.description
        expect(description).to include('Tall')
        expect(description).to include('Athletic')
        expect(description).to include('Fair')
        expect(description).to include('Blue')
        expect(description).to include('Calm')
      end

      it 'handles empty data' do
        npc.data = {}
        expect(npc.description).to eq('No description available')
      end
    end
  end
end
