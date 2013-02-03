class AddAdjustmentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :adjustment, :string
  end
end
