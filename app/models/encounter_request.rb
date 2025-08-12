class EncounterRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :party_level, :integer
  attribute :party_size, :integer
  attribute :shape, :string
  attribute :difficulty, :string
  attribute :theme, :string

  validates :party_level, :party_size, presence: true
  validates :party_level, inclusion: { in: 1..20 }
  validates :party_size, inclusion: { in: 1..8 }
  validates :shape, inclusion: { in: %w[solo_boss two_bosses boss_minions swarm custom] }
  validates :difficulty, inclusion: { in: %w[easy medium hard deadly] }
end
