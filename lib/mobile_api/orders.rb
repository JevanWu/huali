module MobileAPI
  class Orders < Grape::API

    helpers do
    end

    resource :orders do
      desc "Return all of the current user's orders." 
      params do
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end
      get do
        authenticate_user!
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
            ship_method: "#{order.ship_method ? order.ship_method.name : "" }" , 
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
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end
      get ':id' do
        authenticate_user!
        order = current_user.orders.find(params[:id])
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
            ship_method: "#{order.ship_method ? order.ship_method.name : "" }" , 
            kind: order.kind, 
            subject_text: order.subject_text 
        }
      end

      desc "Creates an order"
      params do

        optional :sender_name, type: String, desc: "Sender name"
        optional :sender_email, type: String, desc: "Sender email"
        optional :sender_phone, type: String, desc: "Sender phone"
        optional :coupon_code, type: String, desc: "Coupon code"
        optional :gift_card_text, type: Text, desc: "Gift card text"
        optional :special_instructions, type: Text, desc: "Customer memo"
        optional :memo, type: Text, desc: "Customer service memo"
        requires :kind, type: String, desc: "Order kind, options are normal, taobao and tmall"
        requires :merchant_order_no, type: String, desc: "Merchant order No."
        optional :ship_method_id, type: Integer, desc: "EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5"
        optional :expected_date, type: Date, desc: "Expected arrival date"
        optional :delivery_date, type: Date, desc: "Delivery date"
        requires :receiver_fullname, type: String, desc: "Receiver fullname"
        requires :receiver_phone, type: String, desc: "Receiver phone"
        requires :receiver_province_id, type: Integer, desc: "Receiver province id"
        reuqires :receiver_city_id, type: Integer, desc: "Receiver city id"
        optional :receiver_area_id, type: Integer, desc: "Receiver area(district) id"
        optional :receiver_post_code, type: String, desc: "Receiver post code"
        requires :receiver_address, type: String, desc: "Receiver address"
        
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end
      get ':id' do
        authenticate_user!
        order = current_user.orders.create{ 
          sender_name: params[:sender_name],
          sender_email: params[:sender_email],
          sender_phone: params[:sender_phone],
          coupon_code: params[:coupon_code],
          gift_card_text: params[:gift_card_text],
          special_instructions: params[:special_instructions],
          memo: params[:memo],
          kind: params[:kind],
          merchant_order_no: params[:merchant_order_no],
          ship_method_id: params[:ship_method_id]
          expected_date: params[:expected_date],
          delivery_date: params[:delivery_date],
          receiver_fullname: params[:receiver_fullname]
          receiver_phone: params[:receiver_phone],
          receiver_province_id: params[:receiver_province_id],
          receiver_city_id: params[:receiver_city_id],
          receiver_area_id: params[:receiver_area_id],
          receiver_post_code: params[:receiver_post_code],
          receiver_address: params[:receiver_address]
        }
        error!(order.errors.messages, 500) if order.errors.messages
        status 201
      end
    end
  end
end
