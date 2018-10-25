class ChangeDatatypeGlobalAccessTokenOfMercariUser < ActiveRecord::Migration[5.2]
  def change
    change_column :mercari_users, :global_access_token, :text
  end
end
