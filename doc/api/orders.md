## Order creation

Accept the notification of new order from third-party order system and create a new order.

```
POST /orders
```

Parameters:

+ `sender_name` (optional)          - Sender name
+ `sender_email` (optional)         - Sender email
+ `sender_phone` (optional)         - Sender phone
+ `coupon_code` (optional)          - Coupon code
+ `gift_card_text` (optional)       - Gift card text
+ `special_instructions` (optional) - Special instructions
+ `kind` (required)                 - Order kind, e.g. taobao, tencent
+ `merchant_order_no` (required)    - Merchant order No.
+ `merchant_trade_no` (optional)    - Merchant trade transaction No.
+ `ship_method_id` (optional)       - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
+ `expected_date` (optional)        - Expected arrival date
+ `delivery_date` (optional)        - Delivery date
+ `address_fullname` (required)     - Receiver fullname
+ `address_phone` (required)        - Receiver phone
+ `address_province_id` (required)  - Receiver province id
+ `address_city_id` (required)      - Receiver city id
+ `address_area_id` (optional)      - Receiver area(district) id
+ `address_post_code` (required)    - Receiver post code
+ `address_address` (required)      - Receiver address



## Order line items creation

Create the line items of the order

```
POST /orders/:id/line_items
```

Parameters:

+ `id` (required)                   - The ID, or identifier, or merchant_order_no of order
+ `product_id` (required)           - Order line item product id
+ `price` (required)                - Order line item product price
+ `quantity` (required)             - Order line item product quantity



## Order update

Update order by receiving the notification of order update from third-party order system.

```
PUT /orders/:id
```

Parameters:

+ `id` (required)                   - The ID, or identifier, or merchant_order_no of order
+ `sender_name` (optional)          - Sender name
+ `sender_email` (optional)         - Sender email
+ `sender_phone` (optional)         - Sender phone
+ `coupon_code` (optional)          - Coupon code
+ `gift_card_text` (optional)       - Gift card text
+ `special_instructions` (optional) - Special instructions
+ `kind` (required)                 - Order kind, e.g. tabao, tencent
+ `merchant_order_no` (required)    - Merchant order No.
+ `merchant_trade_no` (optional)    - Merchant trade transaction No.
+ `ship_method_id` (optional)       - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
+ `expected_date` (optional)        - Expected arrival date
+ `delivery_date` (optional)        - Delivery date
+ `address_fullname` (required)     - Receiver fullname
+ `address_phone` (required)        - Receiver phone
+ `address_province_id` (required)  - Receiver province id
+ `address_city_id` (required)      - Receiver city id
+ `address_area_id` (optional)      - Receiver area(district) id
+ `address_post_code` (required)    - Receiver post code
+ `address_address` (required)      - Receiver address



## Order paid

Set order as paid. This API is called when Third-party order system notify us that an order is paid.

```
POST /orders/:id/pay
```

Parameters:

+ `id` (required)                   - The ID, or identifier, or merchant_order_no of order
+ `merchant_trade_no` (required)    - Merchant trade transaction No.
+ `payment` (required)              - The amount of the payment by customer
+ `subject_text` (optional)         - The subject text of the payment

## Order complete

Set order as completed. This API is called when Third-party order system notify us that an order is confirmed receiving or completed.

```
POST /orders/:id/complete
```

Parameters:

+ `id` (required)                   - The ID, or identifier, or merchant_order_no of order
