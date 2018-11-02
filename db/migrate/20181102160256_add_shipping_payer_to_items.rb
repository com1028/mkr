class AddShippingPayerToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :shippingPayer, :integer
  end
end
