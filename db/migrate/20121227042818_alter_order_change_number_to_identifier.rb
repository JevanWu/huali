class AlterOrderChangeNumberToIdentifier < ActiveRecord::Migration
  def change
    rename_column :orders, :number, :identifier
    remove_index :orders, name: :index_orders_on_number
    add_index :orders, ['identifier'], name: 'index_orders_on_identifier', unique: true
  end
end
