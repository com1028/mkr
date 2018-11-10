class CreateExhibitHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :exhibit_histories do |t|
      t.integer :item_id
      t.integer :mercari_user_id
      t.integer :user_id
      t.string :mercari_item_token

      t.timestamps
    end
  end
end
