class MonsterDataLoader
  def self.load_monsters
    file_path = Rails.root.join("config", "fixtures", "monsters.yml")
    return [] unless File.exist?(file_path)

    begin
      yaml_data = YAML.load_file(file_path)
      return [] unless yaml_data.is_a?(Hash)

      yaml_data.map do |key, data|
        MonsterRepository::Monster.new(
          name: data["name"],
          cr: data["cr"],
          xp_value: data["xp_value"],
          tags: data["tags"]
        )
      end
    rescue Psych::SyntaxError, StandardError => e
      Rails.logger.error "Error loading monster data: #{e.message}"
      []
    end
  end
end
