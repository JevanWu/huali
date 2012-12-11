class AddPublishedFieldToProducts < ActiveRecord::Migration
  def change
    add_column :products, :published, :boolean, :default => false
    Product.unscoped.all.each do |product|
      if product.available == true
        product.update_attribute("published", true)
      end
    end
  end
end
