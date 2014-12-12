module MobileAPI
  class Orders < Grape::API

    helpers do

      def products_info(order)
        res = Array.new
        order.line_items.each do |item|
          res << {
                   name_zh: item.product.name_zh,
                   name_en: item.product.name_en,
                   quantity: item.quantity,
                   price: item.product.price,
                   image: item.product.assets.first.image.url(:medium),
                   product_id: item.product.id
          }
        end
        res
      end
    end

    resource :orders do
      desc "Return all of the current user's orders." 
      params do
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
        optional :per_page, type: Integer, desc: "The amount of orders presented on each page"
        optional :page, type: Integer, desc: "The number of page queried"
      end
      get do
        authenticate_user!
        if params[:per_page]&&params[:page]
          orders = current_user.orders.limit(params[:per_page]).offset(params[:per_page]*(params[:page] - 1))
        else
          orders = current_user.orders
        end
        error!('The user has no order now!', 404) if orders.nil?
        res = Array.new
        orders.each do |order|
          order_info  = { 
            id: order.id, 
            identifier: order.identifier, 
            item_total: order.item_total, 
            total: order.total, 
            payment_total: order.payment_total, 
            state: order.state_text, 
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
            subject_text: order.subject_text,
            receiver_fullname: order.address.fullname,
            receiver_province: order.address.province.name,
            receiver_city: order.address.city.name,
            receiver_area: order.address.area.name,
            receiver_address: order.address.address,
            receiver_phone: order.address.phone,
            receiver_post_code: order.address.post_code,
            products: products_info(order)        
          }
          res << order_info
        end
        res
      end

      desc "Query an order by the id"
      params do
        optional :id, type: Integer, desc: "Order id."
        optional :identifier, type: String, desc: "Order identifier."
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end
      get :query do
        authenticate_user!
        if params[:id]
          order = current_user.orders.find(params[:id])
        elsif params[:identifier]
          order = current_user.orders.find_by(identifier: params[:identifier]) 
        else
          return
        end
        error!('There is no such product!', 404) if order.nil?
        error!('This order does not belong to current user!', 403) unless current_user.orders.include? order
        res = { 
            id: order.id, 
            identifier: order.identifier, 
            item_total: order.item_total, 
            total: order.total, 
            payment_total: order.payment_total, 
            state: order.state_text, 
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
            subject_text: order.subject_text,
            receiver_fullname: order.address.fullname,
            receiver_province: order.address.province.name,
            receiver_city: order.address.city.name,
            receiver_area: order.address.area.name,
            receiver_address: order.address.address,
            receiver_phone: order.address.phone,
            receiver_post_code: order.address.post_code,
            products: products_info(order)        
        }
      end

      #order_info: {
      #  sender_name: "..."
      #  sender_email: "..."
      #  sender_phone: "..."
      #  coupon_code: "..."
      #  gift_card_text: "..."
      #  special_instructions: "..."
      #  memo: "..."
      #  ship_method_id: "..."
      #  expected_date: "..."
      #  delivery_date: "..."
      #  receiver_fullname: "..."
      #  receiver_phone: "..."
      #  receiver_province_id: "..."
      #  receiver_city_id: "..."
      #  receiver_area_id: "..."
      #  receiver_post_code: "..."
      #  receiver_address: "..."
      #  products: [
      #              { product_id: "...", price: "...", quantity: "..." }
      #              ...
      #            ]
      # 
      #}
      desc "Creates an order"
      post do
        authenticate_user!
        order_info = params[:order_info]
        error!("order info is required", 404) if !order_info.present?
        order = current_user.orders.new(
          sender_name: order_info[:sender_name],
          sender_email: order_info[:sender_email],
          sender_phone: order_info[:sender_phone],
          coupon_code: order_info[:coupon_code],
          gift_card_text: order_info[:gift_card_text],
          special_instructions: order_info[:special_instructions],
          memo: order_info[:memo],
          kind: "normal",
          ship_method_id: order_info[:ship_method_id],
          expected_date: order_info[:expected_date],
          delivery_date: order_info[:delivery_date],
        )

        address = Address.new(fullname: order_info[:receiver_fullname],
                              phone: order_info[:receiver_phone],
                              province_id: order_info[:receiver_province_id],
                              city_id: order_info[:receiver_city_id],
                              area_id: order_info[:receiver_area_id],
                              address: order_info[:receiver_address],
                              post_code: order_info[:receiver_post_code])

        order.user = current_user
        order.address = address

        error!(order.errors.messages, 500) unless order.save

        products = order_info[:products]
        
        total = BigDecimal.new(0)

        products.each do |product|
          rule_runner = RegionRuleRunner.new(Product.find(product[:product_id]).region_rule)
          error!("Sorry! The products cannot be delivered to this address", 500) unless rule_runner.apply_test(order_info[:receiver_province_id], order_info[:receiver_city_id], order_info[:receiver_area_id])
          if order.line_items.create( product_id: product[:product_id],
                                quantity: product[:quantity],
                                price: product[:price] )
            total += product[:quantity].to_f * product[:price].to_f
          end
        end

        order.update_columns(total: total, item_total: total)

        OrderDiscountPolicy.new(order).apply

        { 
          state: order.state_text,
          total: order.total,
          payment_total: order.payment_total,
          identifier: order.identifier,
          expected_date: order.expected_date,
          receiver_fullname: order.address.fullname,
          receiver_province: order.address.province.name,
          receiver_city: order.address.city.name,
          receiver_area: order.address.area.name,
          receiver_address: order.address.address,
          receiver_phone: order.address.phone,
          receiver_post_code: order.address.post_code,
          products: products_info(order)        
        }
      end

      desc "Check if the coupon code is available"
      params do
        requires :code, type: String, desc: "Coupon code"

        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end

      post ":id/check_coupon_code" do
        authenticate_user!

        coupon_code = CouponCode.find_by(code: params[:code])
        error!("The coupon code doesn't exist", 404) unless coupon_code.present?
        error!("The coupon code has been used out", 404) if coupon_code.available_count <= 0

        { adjustment: coupon_code.coupon.adjustment }
      end

      desc "Creates line items for order"
      params do
        requires :id, type: Integer, desc: "Id of the order"
        requires :product_id, type: Integer, desc: "Id of the product"
        requires :price, type: Float, desc: "price of each product"
        requires :quantity, type: Integer, desc: "quantity of the product"

        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end

      post ":id/line_items" do
        authenticate_user!
        order = current_user.orders.find_by(identifier: params[:id]) || current_user.orders.find(params[:id])
        error!("Order not found", 404) if order.nil? 
        line_item = order.line_items.new( product_id: params[:product_id],
                                quantity: params[:quantity],
                                price: params[:price] )
        if line_item.save
          status(201)
        else
          error!(line_item.errors.messages, 500)
        end
      end

      desc "Cancels the order"
      params do
        requires :id, type: Integer, desc: "Id of the order"
        
        requires :email, type: String, desc: "Email of the user."
        requires :token, type: String, desc: "Authentication token of the user."
      end
      put ':id/cancel' do
        authenticate_user!
        order = current_user.orders.find params[:id]
        error!("Cannot find your order", 404) unless order
        if order.cancel
          status 200
        else
          error!("Order cancellation failed", 500)
        end
      end
    end
  end
end
