class AddTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :type, :string, default: 'normal', null: false
  end
end
