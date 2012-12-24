class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string     :identifier
      t.string     :merchant_name
      t.string     :merchant_trade_no
      t.string     :subject
      t.text       :body
      t.string     :status

      t.references :order
      t.integer    :amount
      t.datetime   :processed_at

      t.timestamps
    end
  end
end
