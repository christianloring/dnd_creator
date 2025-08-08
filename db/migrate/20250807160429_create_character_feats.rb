class CreateCharacterFeats < ActiveRecord::Migration[8.0]
  def change
    create_table :character_feats do |t|
      t.references :character, null: false, foreign_key: true
      t.references :feat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
