class CreateCharacterItems < ActiveRecord::Migration[8.0]
  def change
    create_table :character_items do |t|
      t.references :character, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
