class Run < ApplicationRecord
  belongs_to :game_profile

  validates :stage, presence: true, numericality: { greater_than: 0 }
  validates :result, presence: true, inclusion: { in: %w[win lose] }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_defaults, on: :create

  def self.create_from_game_state(game_profile, stage, result, final_score)
    create!(
      game_profile: game_profile,
      stage: stage,
      result: result,
      score: final_score,
      data: {
        final_level: game_profile.level,
        final_exp: game_profile.exp,
        final_hp: game_profile.hp_current,
        final_gold: game_profile.gold,
        game_data: game_profile.data
      }
    )
  end

  private

  def set_defaults
    self.data ||= {}
  end
end
