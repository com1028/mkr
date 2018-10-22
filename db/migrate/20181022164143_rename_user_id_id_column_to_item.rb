class RenameUserIdIdColumnToItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :user_id_id, :user_id
    rename_column :items, :mercari_user_id_id, :mercari_user_id
  end
end
