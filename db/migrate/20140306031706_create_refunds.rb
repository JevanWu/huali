class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.references :order, index: true
      t.references :transaction, index: true
      t.string :state
      t.string :merchant_refund_id
      t.decimal :amount
      t.string :reason
      t.string :ship_method
      t.string :tracking_number

      t.timestamps
    end

    add_index :refunds, [:order_id, :merchant_refund_id], unique: true
  end
end
