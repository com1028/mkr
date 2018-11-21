class AddColumnToMercariUser < ActiveRecord::Migration[5.2]
  def change
    add_column :mercari_users, :exhibit_interval, :integer, default: 2
  end
end
