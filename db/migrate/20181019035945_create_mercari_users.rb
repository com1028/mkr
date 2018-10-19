class CreateMercariUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :mercari_users do |t|
      t.references :user_id, foreign_key: true
      t.string :image_full_filepath
      t.string :email
      t.string :password
      t.string :name
      t.string :access_token
      t.string :global_access_token
      t.boolean :in_progress

      t.timestamps
    end
  end
end
