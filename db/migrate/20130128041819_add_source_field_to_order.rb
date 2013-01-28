class AddSourceFieldToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :source, :string, null:false, default: ""
  end
end
