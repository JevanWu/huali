class ImportHistorySalesVolume < ActiveRecord::Migration
  def up
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
