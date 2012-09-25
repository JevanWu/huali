class AddInfoSourceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :info_source, :string
    add_column :product_parts, :info_source, :string
  end
end
