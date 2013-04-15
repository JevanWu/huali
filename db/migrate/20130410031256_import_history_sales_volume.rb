class ImportHistorySalesVolume < ActiveRecord::Migration
  def up
    Product.all.each do |p|
      p.sales_volume_totally = 0
      p.save
    end
    binding.pry
  	Order.where(state: "completed").each do |o|
  	  o.line_items.each do |line|
  	    p = line.product
  	    p.sales_volume_totally += line.quantity
  	    p.save
  	  end
  	end
  end

  def down
  end
end
