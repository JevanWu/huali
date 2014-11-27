class AddDeliveryMethodToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_method, :string, default: "normal"
  end
end
