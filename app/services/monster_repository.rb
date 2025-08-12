class MonsterRepository
  Monster = Struct.new(:name, :cr, :xp_value, :tags, keyword_init: true)

  SAMPLE = [
    Monster.new(name: "CR 0 Monster", cr: "0", xp_value: 10, tags: %w[beast]),
    Monster.new(name: "CR 1/8 Monster", cr: "1/8", xp_value: 25, tags: %w[beast]),
    Monster.new(name: "CR 1/4 Monster", cr: "1/4", xp_value: 50, tags: %w[beast]),
    Monster.new(name: "CR 1/2 Monster", cr: "1/2", xp_value: 100, tags: %w[beast]),
    Monster.new(name: "CR 1 Monster", cr: "1", xp_value: 200, tags: %w[beast]),
    Monster.new(name: "CR 2 Monster", cr: "2", xp_value: 450, tags: %w[beast]),
    Monster.new(name: "CR 3 Monster", cr: "3", xp_value: 700, tags: %w[beast]),
    Monster.new(name: "CR 4 Monster", cr: "4", xp_value: 1100, tags: %w[beast]),
    Monster.new(name: "CR 5 Monster", cr: "5", xp_value: 1800, tags: %w[beast]),
    Monster.new(name: "CR 6 Monster", cr: "6", xp_value: 2300, tags: %w[beast]),
    Monster.new(name: "CR 7 Monster", cr: "7", xp_value: 2900, tags: %w[beast]),
    Monster.new(name: "CR 8 Monster", cr: "8", xp_value: 3900, tags: %w[beast]),
    Monster.new(name: "CR 9 Monster", cr: "9", xp_value: 5000, tags: %w[beast]),
    Monster.new(name: "CR 10 Monster", cr: "10", xp_value: 5900, tags: %w[beast]),
    Monster.new(name: "CR 11 Monster", cr: "11", xp_value: 7200, tags: %w[beast]),
    Monster.new(name: "CR 12 Monster", cr: "12", xp_value: 8400, tags: %w[beast]),
    Monster.new(name: "CR 13 Monster", cr: "13", xp_value: 10000, tags: %w[beast]),
    Monster.new(name: "CR 14 Monster", cr: "14", xp_value: 11500, tags: %w[beast]),
    Monster.new(name: "CR 15 Monster", cr: "15", xp_value: 13000, tags: %w[beast]),
    Monster.new(name: "CR 16 Monster", cr: "16", xp_value: 15000, tags: %w[beast]),
    Monster.new(name: "CR 17 Monster", cr: "17", xp_value: 18000, tags: %w[beast]),
    Monster.new(name: "CR 18 Monster", cr: "18", xp_value: 20000, tags: %w[beast]),
    Monster.new(name: "CR 19 Monster", cr: "19", xp_value: 22000, tags: %w[beast]),
    Monster.new(name: "CR 20 Monster", cr: "20", xp_value: 25000, tags: %w[beast]),
    Monster.new(name: "CR 21 Monster", cr: "21", xp_value: 33000, tags: %w[beast]),
    Monster.new(name: "CR 22 Monster", cr: "22", xp_value: 41000, tags: %w[beast]),
    Monster.new(name: "CR 23 Monster", cr: "23", xp_value: 50000, tags: %w[beast]),
    Monster.new(name: "CR 24 Monster", cr: "24", xp_value: 62000, tags: %w[beast]),
    Monster.new(name: "CR 25 Monster", cr: "25", xp_value: 75000, tags: %w[beast]),
    Monster.new(name: "CR 26 Monster", cr: "26", xp_value: 90000, tags: %w[beast]),
    Monster.new(name: "CR 27 Monster", cr: "27", xp_value: 105000, tags: %w[beast]),
    Monster.new(name: "CR 28 Monster", cr: "28", xp_value: 120000, tags: %w[beast]),
    Monster.new(name: "CR 29 Monster", cr: "29", xp_value: 135000, tags: %w[beast]),
    Monster.new(name: "CR 30 Monster", cr: "30", xp_value: 155000, tags: %w[beast])
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
    1 => { easy: 50, medium: 75, hard: 100 },
    2 => { easy: 100, medium: 150, hard: 200 },
    3 => { easy: 150, medium: 225, hard: 400 },
    4 => { easy: 250, medium: 375, hard: 500 },
    5 => { easy: 500, medium: 750, hard: 1100 },
    6 => { easy: 600, medium: 1000, hard: 1400 },
    7 => { easy: 750, medium: 1300, hard: 1700 },
    8 => { easy: 1000, medium: 1700, hard: 2100 },
    9 => { easy: 1300, medium: 2000, hard: 2600 },
    10 => { easy: 1600, medium: 2300, hard: 3100 },
    11 => { easy: 1900, medium: 2900, hard: 4100 },
    12 => { easy: 2200, medium: 3700, hard: 4700 },
    13 => { easy: 2600, medium: 4200, hard: 5400 },
    14 => { easy: 2900, medium: 4900, hard: 6200 },
    15 => { easy: 3300, medium: 5400, hard: 7800 },
    16 => { easy: 3800, medium: 6100, hard: 9800 },
    17 => { easy: 4500, medium: 7200, hard: 11700 },
    18 => { easy: 5000, medium: 8700, hard: 14200 },
    19 => { easy: 5500, medium: 10700, hard: 17200 },
    20 => { easy: 6400, medium: 13200, hard: 22000 }
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
