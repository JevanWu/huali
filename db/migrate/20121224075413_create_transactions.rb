class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string     :identifier
      t.string     :merchant_name
      t.string     :merchant_no
      t.references :order
      t.integer    :amount
      t.string     :status
      t.datetime   :processed_at

      t.timestamps
    end
  end
end
