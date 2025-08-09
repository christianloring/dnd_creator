class GameProfile < ApplicationRecord
  belongs_to :character
  has_many :runs, dependent: :destroy

  validates :level, presence: true, numericality: { greater_than: 0 }
  validates :exp, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hp_current, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_hp, presence: true, numericality: { greater_than: 0 }
  validates :gold, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_defaults, on: :create

  def base_max_hp
    character.hitpoints
  end

  def hp_percentage
    (hp_current.to_f / max_hp * 100).round(1)
  end

  def add_exp(amount)
    self.exp += amount
    check_level_up
  end

  def heal(amount)
    self.hp_current = [ hp_current + amount, max_hp ].min
    save!
  end

  def take_damage(amount)
    self.hp_current = [ hp_current - amount, 0 ].max
    save!
  end

  def add_gold(amount)
    self.gold += amount
    save!
  end

  def reset_progress
    self.level = character.level  # Start at character's original level
    self.exp = 0
    self.max_hp = base_max_hp || 10
    self.hp_current = max_hp
    self.gold = 0
    self.data = {}
    save!
  end

  def check_level_up
    enemies_needed = level
    if exp >= enemies_needed * 10
      self.level += 1
      self.exp = 0
      self.max_hp = base_max_hp + (8 * (level - character.level))  # Base HP + 8 per level gained in game
      self.hp_current = max_hp  # Full heal to new max HP
      save!
      return true
    end
    false
  end

  private

  def set_defaults
    self.level ||= character.level || 1
    self.exp ||= 0
    self.hp_current ||= character.hitpoints || 10
    self.max_hp ||= character.hitpoints || 10
    self.gold ||= 0
    self.data ||= {}
  end
end
