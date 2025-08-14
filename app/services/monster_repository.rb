class MonsterRepository
  Monster = Struct.new(:name, :cr, :xp_value, :tags, keyword_init: true)

  def initialize
    @monsters = MonsterDataLoader.load_monsters
  end

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
    return @monsters if theme.blank?
    @monsters.select { |m| m.tags.include?(theme) }.presence || @monsters
  end
end
