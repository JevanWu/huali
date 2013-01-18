class ChangeAmountToDecimalInTransaction < ActiveRecord::Migration
  def up
    change_column :transactions, :amount, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :transactions, :amount, :integer
  end
end
