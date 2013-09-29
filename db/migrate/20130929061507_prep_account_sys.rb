class PrepAccountSys < ActiveRecord::Migration
  def change
    add_column :products, :sku_id, :string
    add_column :orders, :merchant_order_no, :string
  end
end
