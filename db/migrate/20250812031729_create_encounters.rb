class CreateEncounters < ActiveRecord::Migration[8.0]
  def change
    create_table :encounters do |t|
      t.references :user, null: false, foreign_key: true, index: true

      t.jsonb :inputs, null: false, default: {}
      t.jsonb :composition, null: false, default: {}

      t.integer :total_xp, null: false
      t.string :theme

      t.string :slug, index: { unique: true }  # optional, nice for shareable URLs

      t.timestamps
    end

    add_index :encounters, :theme
    add_index :encounters, :inputs, using: :gin
    add_index :encounters, :composition, using: :gin
  end
end
