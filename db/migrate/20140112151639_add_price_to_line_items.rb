class AddPriceToLineItems < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :line_items, :price, :decimal

        LineItem.all.each do |item|
          item.update_column(:price, item.product.price) if item.product
        end
      end

      dir.down do
        remove_column :line_items, :price
      end
    end
  end
end
