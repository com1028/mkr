class AddDefaultToItemAutoExhibitFlag < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:items, :auto_exhibit_flag, true)
  end
end
