class AddPrintIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :print_id, :integer
    add_index :products, :print_id, unique: true
  end
end
