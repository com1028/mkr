class AddColumnMercariUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :mercari_users, :refresh_token, :string
  end
end
