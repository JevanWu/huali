class UseBooleanInProductsAvailableState < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.remove :available_on, :deleted_at
      t.boolean :available, :default => true
    end
  end

  def down
    change_table :products do |t|
      t.datetime :available_on, :deleted_at
      t.remove :available
    end
  end
end
