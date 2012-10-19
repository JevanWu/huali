class ChangeDescription2ToTextType < ActiveRecord::Migration
  def up
    change_column :products, :description2, :text 
  end

  def down
    change_column :products, :description2, :string 
  end
end
