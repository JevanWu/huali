class AlterOrderChangeNumberToIdentifier < ActiveRecord::Migration
  def change
    rename_column :orders, :number, :identifier
    rename_index :orders, 'index_orders_on_number', 'index_orders_on_identifier'
  end
end
