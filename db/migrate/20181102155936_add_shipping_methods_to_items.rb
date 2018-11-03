class AddShippingMethodsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :shippingMethod, :integer
  end
end
