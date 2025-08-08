class AddSpeedToCharacter < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :speed, :integer, default: 30, null: false
  end
end
