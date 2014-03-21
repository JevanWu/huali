class ChangeDataTypeOfHualiPoint < ActiveRecord::Migration
  def up
    change_column :users, :huali_point, :decimal, precision: 5, scale: 2
    change_column :point_transactions, :point, :decimal, precision: 5, scale: 2
  end

  def down
    change_column :users, :huali_point, :integer 
    change_column :point_transactions, :point, :integer 
  end
end
