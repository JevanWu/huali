class AddPriorityToProducts < ActiveRecord::Migration
  def up
    add_column :products, :priority, :integer, default: 5
  end

  def down
    remove_column :products, :priority
  end
end
