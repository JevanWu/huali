module API
  # Orders API
  class Orders < Grape::API
    before { verify_signature! }

    helpers do
      def order
        if params[:kind] == 'normal'
          Order.find_by_identifier(params[:id]) || Order.find_by_id(params[:id])
        else
          Order.find_by_merchant_order_no_and_kind(params[:id], params[:kind])
        end
      end
    end

    resource :orders do
      # Create an order.
      #
      # Parameters:
      #   sender_name (optional)          - Sender name
      #   sender_email (optional)         - Sender email
      #   sender_phone (optional)         - Sender phone
      #   coupon_code (optional)          - Coupon code
      #   gift_card_text (optional)       - Gift card text
      #   special_instructions (optional) - Customer memo
      #   memo (optional)                 - Customer service memo
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
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
        #requires :address_fullname, type: String
        #requires :address_phone, type: String
        #requires :address_province_id, type: Integer
        #requires :address_city_id, type: Integer
        #optional :address_area_id, type: Integer
        #requires :address_post_code, type: Integer
        #optional :address_address, type: String
      end

      post do
        order = Order.new(sender_name: params[:sender_name],
                          sender_email: params[:sender_email],
                          sender_phone: params[:sender_phone],
                          coupon_code: params[:coupon_code],
                          gift_card_text: params[:gift_card_text],
                          special_instructions: params[:special_instructions],
                          memo: params[:memo],
                          kind: params[:kind],
                          merchant_order_no: params[:merchant_order_no],
                          ship_method_id: params[:ship_method_id],
                          expected_date: params[:expected_date],
                          delivery_date: params[:delivery_date])
        order.source = ['taobao', 'tmall'].include?(params[:kind]) ? '淘宝' : '其他'

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

      # Create line items for an order
      #
      # Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   product_id (required)           - Order line item product id
      #   price (required)                - Order line item product price
      #   quantity (required)             - Order line item product quantity

      # Example Request:
      #   POST /orders/:kind/:id/line_items
      params do
        requires :product_id, type: Integer
        requires :price, type: Float
        requires :quantity, type: Integer
      end

      post ":kind/:id/line_items" do
        not_found!("order") and return unless order
        forbidden! and return if order.state != 'generated'

        order.line_items.create(product_id: params[:product_id],
                                quantity: params[:quantity],
                                price: params[:price])

        status(201)
      end

      # Pay an order
      #
      # Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   merchant_trade_no (required)    - Merchant trade transaction No.
      #   merchant_name (optional)        - Merchant name, available names: Alipay, Paypal and Tenpay, default: Alipay.
      #   payment (required)              - The amount of the payment by customer
      #   subject_text (optional)         - The subject text of the payment
      #   method (optional)               - Available methods: paypal, directPay, wechat, default: directPay

      # Example Request:
      #   PUT /orders/:kind/:id/transactions/completed/:merchant_trade_no
      params do
        optional :merchant_name, type: String, default: 'Alipay'
        requires :payment, type: Float
        optional :subject_text, type: String
        optional :method, type: String, default: 'directPay'
      end

      put ":kind/:id/transactions/completed/:merchant_trade_no" do
        not_found!("order") and return unless order
        status(204) and return if order.state != 'generated'

        transaction = order.transactions.where(merchant_trade_no: params[:merchant_trade_no]).first

        unless transaction
          opts = {
            merchant_name: params[:merchant_name],
            merchant_trade_no: params[:merchant_trade_no],
            amount: params[:payment],
            paymethod: params[:method]
          }
          opts.merge!(subject: params[:subject_text]) if params[:subject_text].present?

          transaction = order.generate_transaction(opts)
        end

        transaction.start if transaction.state == 'generated'
        transaction.complete_deal

        status(205)
      end

      # Complete an order
      #
      # Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall

      # Example Request:
      #   PUT /orders/completed/:kind/:id
      put "completed/:kind/:id" do
        not_found!("order") and return unless order
        status(204) and return if order.state == 'completed'
        forbidden! and return if order.state != 'wait_confirm'

        order.confirm

        status(205)
      end

      # Update memos of an order
      #
      # Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   special_instructions (optional) - Special instructions of customer
      #   memo (optional)                 - Memo of customer service
      put ":kind/:id/memos" do
        not_found!("order") and return unless order

        order.update_column(:special_instructions, params[:special_instructions]) if params[:special_instructions].present?
        order.update_column(:memo, params[:memo]) if params[:memo].present?

        status(205)
      end

      # Create a refund request for an order
      #
      # Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   merchant_trade_no` (required)   - Merchant trade transaction No.
      #   merchant_refund_id` (required)  - Merchant refund id
      #   amount` (required)              - Refunded money
      #   reason` (optional)              - Refund reason
      #   ship_method` (optional)         - Ship method, e.g EMS, Shunfeng
      #   tracking_number` (optional)     - Shipment tracking number
      params do
        requires :merchant_trade_no, type: String
        requires :merchant_refund_id, type: String
        requires :amount, type: Float
        optional :reason, type: String
        optional :ship_method, type: String
        optional :tracking_number, type: String
      end

      post ":kind/:id/refunds" do
        not_found!("order") and return unless order

        transaction = order.transactions.where(merchant_trade_no: params[:merchant_trade_no]).first

        unless transaction
          render_api_error!("merchant_trade_no##{params[:merchant_trade_no]} not found", 400, { order: order.identifier }) and return
        end

        permitted_params = ActionController::Parameters.new(params).permit(:merchant_refund_id, :reason, :ship_method, :tracking_number)

        order.generate_refund(transaction, params[:amount], permitted_params)

        status(201)
      end

      # Accept a refund of an order
      #  Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   merchant_trade_no` (required)   - Merchant trade transaction No.
      #   merchant_refund_id` (required)  - Merchant refund id
      #   amount` (required)              - Refunded money
      #   reason` (optional)              - Refund reason
      #   ship_method` (optional)         - Ship method, e.g EMS, Shunfeng
      #   tracking_number` (optional)     - Shipment tracking number

      params do
        requires :merchant_trade_no, type: String
        requires :amount, type: Float
        optional :reason, type: String
        optional :ship_method, type: String
        optional :tracking_number, type: String
      end

      put ":kind/:id/refunds/accepted/:merchant_refund_id" do
        not_found!("order") and return unless order

        refund = order.refunds.where(merchant_refund_id: params[:merchant_refund_id]).first

        unless refund
          transaction = order.transactions.where(merchant_trade_no: params[:merchant_trade_no]).first

          unless transaction
            render_api_error!("merchant_trade_no##{params[:merchant_trade_no]} not found", 400, { order: order.identifier }) and return
          end

          permitted_params = ActionController::Parameters.new(params).permit(:merchant_refund_id, :reason, :ship_method, :tracking_number)
          order.generate_refund(transaction, params[:amount], permitted_params)
        end

        OrderRefundService.accept_refund(order, refund)

        status(205)
      end

      # Reject a refund of an order
      #  Parameters:
      #   id (required)                   - Either ID, identifier, or merchant_order_no of the order
      #   kind (required)                 - Order kind, options are normal, taobao and tmall
      #   merchant_trade_no` (required)   - Merchant trade transaction No.
      #   merchant_refund_id` (required)  - Merchant refund id
      #   amount` (required)              - Refunded money
      #   reason` (optional)              - Refund reason
      #   ship_method` (optional)         - Ship method, e.g EMS, Shunfeng
      #   tracking_number` (optional)     - Shipment tracking number

      params do
        requires :merchant_trade_no, type: String
        requires :amount, type: Float
        optional :reason, type: String
        optional :ship_method, type: String
        optional :tracking_number, type: String
      end

      put ":kind/:id/refunds/rejected/:merchant_refund_id" do
        not_found!("order") and return unless order

        refund = order.refunds.where(merchant_refund_id: params[:merchant_refund_id]).first

        unless refund
          transaction = order.transactions.where(merchant_trade_no: params[:merchant_trade_no]).first

          unless transaction
            render_api_error!("merchant_trade_no##{params[:merchant_trade_no]} not found", 400, { order: order.identifier }) and return
          end

          permitted_params = ActionController::Parameters.new(params).permit(:merchant_refund_id, :reason, :ship_method, :tracking_number)
          order.generate_refund(transaction, params[:amount], permitted_params)
        end

        OrderRefundService.reject_refund(order, refund)

        status(205)
      end
    end

  end
end

