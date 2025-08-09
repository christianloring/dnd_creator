class AddMaxHpToGameProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :game_profiles, :max_hp, :integer
  end
end
