class RenameDeliveryDate < ActiveRecord::Migration
  def change
    rename_column :orders, :delivery_date, :expected_date
  end
end
