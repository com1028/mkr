class AddLastAutoExhibitDateToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :last_auto_exhibit_date, :date
  end
end
