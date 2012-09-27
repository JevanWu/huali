class ChangColumnInfosource < ActiveRecord::Migration
  def up
    change_column :products, :info_source, :text
    change_column :product_parts, :info_source, :text
  end

  def down
    change_column :products, :info_source, :string
    change_column :product_parts, :info_source, :string
  end
end
