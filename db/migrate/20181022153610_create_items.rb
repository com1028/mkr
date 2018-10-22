class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :user_id, foreign_key: true
      t.references :mercari_user_id, foreign_key: true
      t.string :image1
      t.string :image2
      t.string :image3
      t.string :image4
      t.string :item_name
      t.integer :category
      t.integer :shipping_duration
      t.integer :item_condition
      t.integer :price
      t.integer :shipping_from_area
      t.integer :shipping_duration
      t.text :contents
      t.boolean :auto_exhibit_flag

      t.timestamps
    end
  end
end
