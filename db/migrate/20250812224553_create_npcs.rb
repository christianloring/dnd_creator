class CreateNpcs < ActiveRecord::Migration[8.0]
  def change
    create_table :npcs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.jsonb :data

      t.timestamps
    end
  end
end
