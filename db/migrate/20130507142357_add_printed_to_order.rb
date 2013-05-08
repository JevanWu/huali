class AddPrintedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :printed, :boolean, default: false
  end
end
