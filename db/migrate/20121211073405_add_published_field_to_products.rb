class AddPublishedFieldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :published, :boolean
  end
end
