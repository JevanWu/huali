class AddProductTypeToProduct < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :products, :product_type, :string

        [22, 23, 28, 102, 125, 44, 135, 117, 132, 114, 87, 
          145, 154, 91, 48, 53, 131, 29, 52, 25, 75, 148, 
          51, 92, 167, 168, 169, 170].each do |p_id|
            if product = Product.find(p_id)
              product.update_column(:product_type, "fresh_flower")
            end
          end

        [144, 143, 142, 141, 140, 139, 138, 137, 136, 129,
          128, 127, 126, 121, 97, 82, 81, 68, 67, 66, 65, 
          64, 58, 57, 56, 55, 51, 41, 33, 32, 31, 30, 27, 
          26, 19, 18, 17, 16, 15, 14, 13, 12].each do |p_id|
            if product = Product.find(p_id)
              product.update_column(:product_type, "others")
            end
          end

        [163, 164].each do |p_id|
          if product = Product.find(p_id)
            product.update_column(:product_type, "fake_flower")
          end
        end

        Product.all.each do |product|
          if product.product_type == nil
            product.update_column(:product_type, "preserved_flower")
          end
        end
      end
      
      dir.down do
        remove_column :products, :product_type
      end
    end
  end
end
