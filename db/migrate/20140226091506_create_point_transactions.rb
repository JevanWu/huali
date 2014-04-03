class CreatePointTransactions < ActiveRecord::Migration
  def change
    create_table :point_transactions do |t|
      t.integer :point, :default => 0
      t.string :transaction_type
      t.string :description
      t.date :expires_on
      t.references :user, index: true
      t.references :transaction, index: true

      t.timestamps
    end
  end
end
