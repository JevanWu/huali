class AddFlowerTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :flower_type, :string
  end
end
