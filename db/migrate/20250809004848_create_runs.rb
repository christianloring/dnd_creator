class CreateRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :runs do |t|
      t.references :game_profile, null: false, foreign_key: true
      t.integer :stage
      t.string :result
      t.integer :score
      t.jsonb :data

      t.timestamps
    end
  end
end
