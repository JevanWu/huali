class AlterOrderChangeNumberToIdentifier < ActiveRecord::Migration
  def change
    rename_column :orders, :number, :identifier
    add_index :orders, ['identifier'], name: 'index_orders_on_identifier', unique: true
  end
end
