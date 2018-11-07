class CreateExhibitHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :exhibit_histories do |t|
      t.references :item
      t.references :mercari_user
      t.references :user
      t.string :mercari_item_token

      t.timestamps
    end
  end
end
