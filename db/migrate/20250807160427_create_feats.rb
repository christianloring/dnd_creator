class CreateFeats < ActiveRecord::Migration[8.0]
  def change
    create_table :feats do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
