class RenameMercariUserColumnToUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :mercari_users, :user_id_id, :user_id
  end
end
