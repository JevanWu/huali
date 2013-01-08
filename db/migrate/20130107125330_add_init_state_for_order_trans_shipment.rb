class AddInitStateForOrderTransShipment < ActiveRecord::Migration
  def change
    change_column_default :orders, :state, 'generated'
    change_column_default :transactions, :state, 'generated'
    change_column_default :orders, :state, 'ready'
  end
end
