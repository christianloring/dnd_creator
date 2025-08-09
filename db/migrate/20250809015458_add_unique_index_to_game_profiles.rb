class AddUniqueIndexToGameProfiles < ActiveRecord::Migration[8.0]
  def change
    unless index_exists?(:game_profiles, :character_id)
      add_index :game_profiles, :character_id, unique: true
    end
  end
end
