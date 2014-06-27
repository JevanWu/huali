namespace :erp do
  desc "Check orders whether they were shipped in ERP system"
  task check_shipped_orders: :environment do
    orders = Order.select(:identifier).where(delivery_date: 40.days.ago.to_date .. Date.current)
    shipped_orders = Erp::Seorder.joins(:seorder_entries).
      select('[SEOrder].[FBillNo]').
      where(FbillNo: orders.map(&:identifier)).
      where("[SEOrderEntry].[FCommitQty] > 0").map(&:FBillNo)

    shipped_orders.each do |identifier|
      order = Order.includes(:shipments).find_by_identifier(identifier)
      order.make if order.state == 'wait_make'
      order.reload
      order.shipment.ship if order.state == 'wait_ship'
    end
  end
end
