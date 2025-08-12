class MonsterRepository
  Monster = Struct.new(:name, :cr, :xp_value, :tags, keyword_init: true)

  SAMPLE = [
    Monster.new(name: "Balor", cr: 19, xp_value: 22000, tags: %w[fiend demon fire]),
    Monster.new(name: "Fire Elemental", cr: 5, xp_value: 1800, tags: %w[elemental fire]),
    Monster.new(name: "Imp", cr: 1, xp_value: 200, tags: %w[fiend devil fire])
  ]

  def best_boss_for(budget, theme: nil)
    pool = themed(theme)
    pool.select { |m| m.xp_value <= budget }.max_by(&:xp_value)
  end

  def good_minion_for(budget, theme: nil)
    pool = themed(theme)
    pool.select { |m| m.xp_value <= budget / 2 }.max_by(&:xp_value) || pool.min_by(&:xp_value)
  end

  private

  def themed(theme)
    return SAMPLE if theme.blank?
    SAMPLE.select { |m| m.tags.include?(theme) }.presence || SAMPLE
  end
end

# app/services/encounter_rules_2024.rb
class EncounterRules2024
  # XP budget per character by party level and difficulty
  XP_BY_LEVEL_AND_DIFFICULTY = {
    1 => { low: 50, medium: 75, high: 100 },
    2 => { low: 100, medium: 150, high: 200 },
    3 => { low: 150, medium: 225, high: 400 },
    4 => { low: 250, medium: 375, high: 500 },
    5 => { low: 500, medium: 750, high: 1100 },
    6 => { low: 600, medium: 1000, high: 1400 },
    7 => { low: 750, medium: 1300, high: 1700 },
    8 => { low: 1000, medium: 1700, high: 2100 },
    9 => { low: 1300, medium: 2000, high: 2600 },
    10 => { low: 1600, medium: 2300, high: 3100 },
    11 => { low: 1900, medium: 2900, high: 4100 },
    12 => { low: 2200, medium: 3700, high: 4700 },
    13 => { low: 2600, medium: 4200, high: 5400 },
    14 => { low: 2900, medium: 4900, high: 6200 },
    15 => { low: 3300, medium: 5400, high: 7800 },
    16 => { low: 3800, medium: 6100, high: 9800 },
    17 => { low: 4500, medium: 7200, high: 11700 },
    18 => { low: 5000, medium: 8700, high: 14200 },
    19 => { low: 5500, medium: 10700, high: 17200 },
    20 => { low: 6400, medium: 13200, high: 22000 }
  }

  # Returns the total XP budget for the party
  # difficulty: :low, :moderate, or :high
  def xp_budget(party_level:, party_size:, difficulty:)
    per_char = XP_BY_LEVEL_AND_DIFFICULTY.fetch(party_level).fetch(difficulty.to_sym)
    per_char * party_size
  end

  # Suggests a solo boss monster for the party and theme
  def pick_solo_boss(party_level:, party_size:, theme: nil, repository: MonsterRepository.new)
    budget = xp_budget(party_level: party_level, party_size: party_size, difficulty: :high)
    repository.best_boss_for(budget, theme: theme)
  end

  # Suggests a good minion monster for the party and theme
  def pick_minion(party_level:, party_size:, theme: nil, repository: MonsterRepository.new)
    budget = xp_budget(party_level: party_level, party_size: party_size, difficulty: :moderate)
    repository.good_minion_for(budget, theme: theme)
  end
end
