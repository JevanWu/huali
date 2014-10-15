class AddExtraAttrsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :material, :text
    add_column :products, :maintenance, :text
    add_column :products, :delivery, :text
  end
end
