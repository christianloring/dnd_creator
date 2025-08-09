class CreateGameProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :game_profiles do |t|
      t.references :character, null: false, foreign_key: true
      t.integer :level
      t.integer :exp
      t.integer :hp_current
      t.integer :gold
      t.jsonb :data

      t.timestamps
    end
  end
end
