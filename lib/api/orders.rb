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
        requires :address_area_id, type: Integer
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
    end
  end
end

