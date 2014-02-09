module API
  # Orders API
  class Orders < Grape::API
    before { verify_signature! }

    resource :orders do
      # Create order.
      #
      # Parameters:
      #   sender_name (optional)          - Sender name
      #   sender_email (optional)         - Sender email
      #   sender_phone (optional)         - Sender phone
      #   coupon_code (optional)          - Coupon code
      #   gift_card_text (optional)       - Gift card text
      #   special_instructions (optional) - Special instructions
      #   kind (required)                 - Order kind, e.g. tabao, tencent
      #   merchant_order_no (required)    - Merchant order No.
      #   ship_method_id (optional)       - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
      #   expected_date (optional)        - Expected arrival date
      #   delivery_date (optional)        - Delivery date
      #   address_fullname (required)     - Receiver fullname
      #   address_phone (required)        - Receiver phone
      #   address_province_id (required)  - Receiver province id
      #   address_city_id (required)      - Receiver city id
      #   address_area_id (optional)      - Receiver area(district) id
      #   address_post_code (required)    - Receiver post code
      #   address_address (required)      - Receiver address

      # Example Request:
      #   POST /orders
      params do
        requires :kind, type: String
        requires :merchant_order_no, type: String
        requires :address_fullname, type: String
        requires :address_phone, type: String
        requires :address_province_id, type: Integer
        requires :address_city_id, type: Integer
        optional :address_area_id, type: Integer
        requires :address_post_code, type: Integer
        requires :address_address, type: String
      end

      post do
        order = Order.new(sender_name: params[:sender_name],
                          sender_email: params[:sender_email],
                          sender_phone: params[:sender_phone],
                          coupon_code: params[:coupon_code],
                          gift_card_text: params[:gift_card_text],
                          special_instructions: params[:special_instructions],
                          kind: params[:kind],
                          merchant_order_no: params[:merchant_order_no],
                          ship_method_id: params[:ship_method_id],
                          expected_date: params[:expected_date],
                          delivery_date: params[:delivery_date])

        address = Address.new(fullname: params[:address_fullname],
                              phone: params[:address_phone],
                              province_id: params[:address_province_id],
                              city_id: params[:address_city_id],
                              area_id: params[:address_area_id],
                              address: params[:address_address],
                              post_code: params[:address_post_code])

        order.user = guest_user
        order.address = address

        if order.save
          status(201)
        else
          validation_error!(order)
        end
      end

      # Update order.
      #
      # Parameters:
      #   id (required)                   - The ID, or identifier, or merchant_order_no of order
      #   sender_name (optional)          - Sender name
      #   sender_email (optional)         - Sender email
      #   sender_phone (optional)         - Sender phone
      #   coupon_code (optional)          - Coupon code
      #   gift_card_text (optional)       - Gift card text
      #   special_instructions (optional) - Special instructions
      #   kind (required)                 - Order kind, e.g. tabao, tencent
      #   merchant_order_no (required)    - Merchant order No.
      #   ship_method_id (optional)       - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
      #   expected_date (optional)        - Expected arrival date
      #   delivery_date (optional)        - Delivery date
      #   address_fullname (required)     - Receiver fullname
      #   address_phone (required)        - Receiver phone
      #   address_province_id (required)  - Receiver province id
      #   address_city_id (required)      - Receiver city id
      #   address_area_id (optional)      - Receiver area(district) id
      #   address_post_code (required)    - Receiver post code
      #   address_address (required)      - Receiver address

      # Example Request:
      #   PUT /orders/:id
      put ":id" do
      end

      # Create the line items of the order.
      #
      # Parameters:
      #   id (required)                   - The ID, or identifier, or merchant_order_no of order
      #   kind (optional)                 - Order kind, e.g. taobao, tencent, default: normal
      #   product_id (required)           - Order line item product id
      #   price (required)                - Order line item product price
      #   quantity (required)             - Order line item product quantity

      # Example Request:
      #   POST /orders/:id/line_items
      params do
        optional :kind, type: String, default: 'normal'
        requires :product_id, type: Integer
        requires :price, type: Float
        requires :quantity, type: Integer
      end

      post ":id/line_items" do
        @order = Order.find_by_merchant_order_no_and_kind(params[:id], params[:kind]) ||
          Order.find_by_identifier_and_kind(params[:id], params[:kind]) ||
          Order.find_by_id_and_kind(params[:id], params[:kind])

        not_found!("order") and return if @order.blank?
        forbidden! and return if @order.state != 'generated'

        @order.line_items.create(product_id: params[:product_id],
                                 quantity: params[:quantity],
                                 price: params[:price])

        status(201)
      end

      # Set order as paid. This API is called when Third-party order system notify us that an order is paid.
      #
      # Parameters:
      #   id (required)                   - The ID, or identifier, or merchant_order_no of order
      #   merchant_trade_no (required)    - Merchant trade transaction No.
      #   merchant_name (optional)        - Merchant name, available names: Alipay, Paypal and Tenpay, default: Alipay.
      #   kind (optional)                 - Order kind, e.g. taobao, tencent, default: normal
      #   payment (required)              - The amount of the payment by customer
      #   subject_text (optional)         - The subject text of the payment
      #   method (optional)               - Available methods: paypal, directPay, wechat, default: directPay

      # Example Request:
      #   POST /orders/:id/pay
      params do
        requires :merchant_trade_no, type: String
        optional :merchant_name, type: String, default: 'Alipay'
        optional :kind, type: String, default: 'normal'
        requires :payment, type: Float
        optional :subject_text, type: String
        optional :method, type: String, default: 'directPay'
      end

      post ":id/pay" do
        @order = Order.find_by_merchant_order_no_and_kind(params[:id], params[:kind]) ||
          Order.find_by_identifier_and_kind(params[:id], params[:kind]) ||
          Order.find_by_id_and_kind(params[:id], params[:kind])

        not_found!("order") and return if @order.blank?
        forbidden! and return if @order.state != 'generated'

        @transaction = @order.transactions.where(merchant_trade_no: params[:merchant_trade_no]).first

        unless @transaction
          opts = {
            merchant_name: params[:merchant_name],
            merchant_trade_no: params[:merchant_trade_no],
            amount: params[:payment],
            paymethod: params[:method]
          }
          opts.merge!(subject: params[:subject_text]) if params[:subject_text].present?

          @transaction = @order.generate_transaction(opts)
        end

        @transaction.start if @transaction.state == 'generated'
        @transaction.complete_deal

        status(200)
      end

      # Set order as completed. This API is called when Third-party order system notify us that an order is confirmed receiving or completed.
      #
      # Parameters:
      #   id (required)                   - The ID, or identifier, or merchant_order_no of order
      #   kind (optional)                 - Order kind, e.g. taobao, tencent, default: normal

      # Example Request:
      #   POST /orders/:id/complete
      params do
        optional :kind, type: String, default: 'normal'
      end

      post ":id/complete" do
        @order = Order.find_by_merchant_order_no_and_kind(params[:id], params[:kind]) ||
          Order.find_by_identifier_and_kind(params[:id], params[:kind]) ||
          Order.find_by_id_and_kind(params[:id], params[:kind])

        not_found!("order") and return if @order.blank?
        forbidden! and return if @order.state != 'wait_confirm'

        @order.confirm

        status(200)
      end
    end
  end
end

