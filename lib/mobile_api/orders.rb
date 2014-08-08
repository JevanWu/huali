module MobileAPI
  class Orders < Grape::API

    helpers do
    end

    resource :orders do
      desc "Return all of the current user's orders." 
      get do
        orders = current_user.orders
        error!('The user has no order now!', 400) if orders.nil?
        res = Array.new
        orders.each do |order|
          order_info  = { id: order.id, identifier: order.identifier, item_total: order.item_total, total: order.total, payment_total: order.payment_total, state: order.state, special_instructions: order.special_instructions, address_id: order.address_id, user_id: order.user_id, gift_card_text: order.gift_card_text, expected_date: order.expected_date, sender_email: order.sender_email, sender_phone: order.sender_phone, sender_name: order.sender_name, delivery_date: order.delivery_date, source: order.source, adjustment: order.adjustment, ship_method_id: order.ship_method_id, printed: order.printed, kind: order.kind, coupon_code_id: order.coupon_code_id, merchant_order_no: order.merchant_order_no, subject_text: order.subject_text, validation_code: order.validation_code }
          res << order_info
        end
        res
      end

      desc "Return the required order of current user"
      params do
        requires :id, type: Integer, desc: "Order id."
      end
      get ':id' do
        order = Order.find(params[:id])
        error!('There is no such product!', 400) if order.nil?
        error!('This order does not belong to current user!', 400) unless current_user.orders.include? order
        res = { id: order.id, identifier: order.identifier, item_total: order.item_total, total: order.total, payment_total: order.payment_total, state: order.state, special_instructions: order.special_instructions, address_id: order.address_id, user_id: order.user_id, gift_card_text: order.gift_card_text, expected_date: order.expected_date, sender_email: order.sender_email, sender_phone: order.sender_phone, sender_name: order.sender_name, delivery_date: order.delivery_date, source: order.source, adjustment: order.adjustment, ship_method_id: order.ship_method_id, printed: order.printed, kind: order.kind, coupon_code_id: order.coupon_code_id, merchant_order_no: order.merchant_order_no, subject_text: order.subject_text, validation_code: order.validation_code }
      end
    end
  end
end
