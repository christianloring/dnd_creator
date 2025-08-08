class CreateCampaignCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_characters do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
