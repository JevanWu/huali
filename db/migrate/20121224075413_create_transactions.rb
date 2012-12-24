class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string     :identifier
      t.string     :trade_no
      t.string     :merchant_name
      t.string     :merchant_no
      t.references :order
      t.string     :service
      t.integer    :amount
      t.string     :status
      t.datetime   :processed_at

      t.timestamps
    end
  end
end
