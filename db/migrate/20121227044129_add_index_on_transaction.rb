class AddIndexOnTransaction < ActiveRecord::Migration
  def change
    add_index :transactions, ['identifier'], name: 'index_transactions_on_identifier', unique: true
    add_index :transactions, ['order_id'], name: 'index_transactions_on_order_id'
  end
end
