class ChangePrecisionOfHualiPoint < ActiveRecord::Migration
  def change
    change_column :users, :huali_point, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :point_transactions, :point, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
