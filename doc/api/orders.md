## Order creation

Accept the notification of new order from third-party order system and create a new order

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
+ `kind` (required)                 - Order kind, e.g. tabao, tencent
+ `merchant_order_no` (required)    - Merchant order No.
+ `merchant_trade_no` (required)    - Merchant transaction No.
+ `ship_method_id` (optional)       - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
+ `expected_date` (optional)        - Expected arrival date
+ `bypass_date_validation` (optional) - Bypass date validation(expected arrival date)
+ `bypass_region_validation` (optional) - Bypass delivery region validation
+ `bypass_product_validation` (optional) - Bypass product validation
+ `delivery_date` (optional)        - Delivery date
+ `address_fullname` (required)     - Receiver fullname
+ `address_phone` (required)        - Receiver phone
+ `address_province_id` (required)  - Receiver province id
+ `address_city_id` (required)      - Receiver city id
+ `address_area_id` (optional)      - Receiver area(district) id
+ `address_post_code` (required)    - Receiver post code
+ `address_address` (required)      - Receiver address


