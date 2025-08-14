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
  # difficulty: :easy, :medium, or :hard
  def xp_budget(party_level:, party_size:, difficulty:)
    per_char = XP_BY_LEVEL_AND_DIFFICULTY.fetch(party_level).fetch(difficulty.to_sym)
    per_char * party_size
  end

  # Suggests a solo boss monster for the party and theme
  def pick_solo_boss(party_level:, party_size:, theme: nil, repository: MonsterRepository.new)
    budget = xp_budget(party_level: party_level, party_size: party_size, difficulty: :hard)
    repository.best_boss_for(budget, theme: theme)
  end

  # Suggests a good minion monster for the party and theme
  def pick_minion(party_level:, party_size:, theme: nil, repository: MonsterRepository.new)
    budget = xp_budget(party_level: party_level, party_size: party_size, difficulty: :medium)
    repository.good_minion_for(budget, theme: theme)
  end
end
