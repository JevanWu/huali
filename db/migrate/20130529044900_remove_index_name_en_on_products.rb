class RemoveIndexNameEnOnProducts < ActiveRecord::Migration
  def up
    remove_index :products, :name_en
  end

  def down
    add_index :products, :name_en
  end
end
