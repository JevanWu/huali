module MobileAPI
  class Orders < Grape::API

    helpers do
    end

    resource :orders do
      desc "Return all of the current user's orders." 
      get do
        orders = current_user.orders
        error!('The user has no order now!', 404) if orders.nil?
        res = Array.new
        orders.each do |order|
          order_info  = { 
            id: order.id, 
            identifier: order.identifier, 
            item_total: order.item_total, 
            total: order.total, 
            payment_total: order.payment_total, 
            state: order.state, 
            address: order.address.address, 
            gift_card_text: order.gift_card_text, 
            expected_date: order.expected_date, 
            sender_email: order.sender_email, 
            sender_phone: order.sender_phone, 
            sender_name: order.sender_name, 
            delivery_date: order.delivery_date, 
            adjustment: order.adjustment, 
            ship_method: order.ship_method.name, 
            kind: order.kind, 
            subject_text: order.subject_text 
          }
          res << order_info
        end
        res
      end

      desc "Query an order by the id"
      params do
        requires :id, type: Integer, desc: "Order id."
      end
      get ':id' do
        order = Order.find(params[:id])
        error!('There is no such product!', 404) if order.nil?
        error!('This order does not belong to current user!', 403) unless current_user.orders.include? order
        res = { 
            id: order.id, 
            identifier: order.identifier, 
            item_total: order.item_total, 
            total: order.total, 
            payment_total: order.payment_total, 
            state: order.state, 
            address: order.address.address, 
            gift_card_text: order.gift_card_text, 
            expected_date: order.expected_date, 
            sender_email: order.sender_email, 
            sender_phone: order.sender_phone, 
            sender_name: order.sender_name, 
            delivery_date: order.delivery_date, 
            adjustment: order.adjustment, 
            ship_method: order.ship_method.name, 
            kind: order.kind, 
            subject_text: order.subject_text 
        }
      end
    end
  end
end
