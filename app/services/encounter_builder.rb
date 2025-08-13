class EncounterBuilder
  Result = Struct.new(:total_xp_budget, :monsters, :notes, keyword_init: true)
  MonsterPick = Struct.new(:name, :cr, :count, :tags, :xp_each, :xp_total, keyword_init: true)

  def initialize(monster_repo: MonsterRepository.new, rules: EncounterRules2024.new)
    @monsters = monster_repo
    @rules = rules
  end

  def call(req)
    xp_budget = @rules.xp_budget(
      party_level: req.party_level,
      party_size: req.party_size,
      difficulty: req.difficulty
    )

    picks =
      case req.shape
      when "solo_boss"
        pick_solo_boss(req, xp_budget)
      when "two_bosses"
        pick_double_boss(req, xp_budget)
      when "boss_minions"
        pick_boss_minions(req, xp_budget)
      when "swarm"
        pick_swarm(req, xp_budget)
      else
        []
      end

    Result.new(total_xp_budget: xp_budget, monsters: picks, notes: [])
  end

  private

  def pick_solo_boss(req, budget)
    boss = @monsters.best_boss_for(budget, theme: req.theme)
    return [] unless boss
    [ wrap_pick(boss, 1) ]
  end

  def pick_double_boss(req, budget)
    each_budget = (budget * 0.55).to_i
    bosses = 2.times.map { @monsters.best_boss_for(each_budget, theme: req.theme) }.compact
    bosses.map { |m| wrap_pick(m, 1) }
  end

  def pick_boss_minions(req, budget)
    boss_budget = (budget * 0.6).to_i
    boss = @monsters.best_boss_for(boss_budget, theme: req.theme)
    return [] unless boss

    minion_budget = budget - boss.xp_value
    minion = @monsters.good_minion_for(minion_budget, theme: req.theme)
    return [] unless minion

    count = [ (minion_budget / minion.xp_value), 6 ].min
    [ wrap_pick(boss, 1), wrap_pick(minion, count) ]
  end

  def pick_swarm(req, budget)
    m = @monsters.good_minion_for(budget, theme: req.theme)
    count = [ budget / m.xp_value, 12 ].min
    [ wrap_pick(m, count) ]
  end

  def wrap_pick(monster, count)
    MonsterPick.new(
      name: monster.name,
      cr: monster.cr,
      count: count,
      tags: monster.tags,
      xp_each: monster.xp_value,
      xp_total: monster.xp_value * count
    )
  end
end
