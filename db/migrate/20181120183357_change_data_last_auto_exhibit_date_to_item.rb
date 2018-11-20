class ChangeDataLastAutoExhibitDateToItem < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :last_auto_exhibit_date, :time
  end

end
