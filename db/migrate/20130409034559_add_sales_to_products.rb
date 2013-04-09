class AddSalesToProducts < ActiveRecord::Migration
  def up
    add_column :products, :sales_volume_totally, :integer, :default => 0

    Order.where(state: "completed").each do |o|
      o.line_items.each do |line|
        p = Product.find(line.product_id)
        binding.pry
        p.sales_volume_totally += line.quantity
        p.save
      end
    end
  end

  def down
  	remove_column :products, :sales_volume_totally
  end
end
