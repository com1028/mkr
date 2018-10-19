class AddDefaultToMercariUsersInProgress < ActiveRecord::Migration[5.2]
  def change
    # デフォルト値を設定
    change_column_default :mercari_users, :in_progress, false

    # NULL制約を設定
    change_column_null :mercari_users, :user_id, false
    change_column_null :mercari_users, :email, false
    change_column_null :mercari_users, :password, false
    change_column_null :mercari_users, :name, false
    change_column_null :mercari_users, :access_token, false
    change_column_null :mercari_users, :global_access_token, false
  end
end
