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

  desc "improt refund orders to erp"
  task import_refund_orders: :environment do
    start_date = "2014-04-01".to_date
    end_date = Date.current

    orders = Order.includes({ line_items: :product }, :transactions, :shipments, :ship_method).
      where(delivery_date: start_date..end_date).
      where(state: "refunded").
      where(kind: ['normal', 'taobao', 'tmall']).to_a

    orders.each do |order|
      ErpWorker::ImportOrder.perform_async(order.id)
    end
  end
end
