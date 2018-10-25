class ChangeDatatypeAccessTokenOfMercariUser < ActiveRecord::Migration[5.2]
  def change
    change_column :mercari_users, :access_token, :text
  end
end
