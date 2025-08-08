class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :character_class
      t.string :subclass
      t.string :species
      t.integer :level
      t.integer :strength
      t.integer :dexterity
      t.integer :constitution
      t.integer :intelligence
      t.integer :wisdom
      t.integer :charisma

      t.timestamps
    end
  end
end
