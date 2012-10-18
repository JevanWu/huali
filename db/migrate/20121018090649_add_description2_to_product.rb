class AddDescription2ToProduct < ActiveRecord::Migration
  def change
    add_column :products, :description2, :string
  end
end
