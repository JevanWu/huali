namespace :shipment do
  desc "complete the shipment and order automatically once it has been 7 days after customer received the product"
  task auto_confirm_received: :environment do
    due_shipments = Shipment.where(state: 'shipped', kuaidi100_status: '3', kuaidi100_updated_at: -7.days.from_now.beginning_of_day .. -7.days.from_now.end_of_day)
    due_shipments.each { |shipment| shipment.accept }
  end
end
