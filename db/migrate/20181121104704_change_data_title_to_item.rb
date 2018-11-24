class ChangeDataTitleToItem < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :last_auto_exhibit_date, :string
  end
end
