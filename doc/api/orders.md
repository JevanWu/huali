## Create an order

Create an new order

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
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `merchant_order_no` (required)    - Merchant order No.
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

```
Status: 201 Created
```

## Create line items for an order

```
POST /orders/:kind/:id/line_items
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `product_id` (required)           - Order line item product id
+ `price` (optional)                - Order line item product price, it use the local product price if not provinded
+ `quantity` (required)             - Order line item product quantity

```
Status: 201 Created

{
  "id": 1,
  "order_id": 9,
  "product_id": 22,
  "quantity": 2,
  "price": 299.0
}
```

## Pay an order

Create an success transaction indicating the order was paid.

```
PUT /orders/:kind/:id/transactions/completed/:merchant_trade_no
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `merchant_trade_no` (required)    - Merchant trade transaction No.
+ `merchant_name` (optional)        - Merchant name, available names: Alipay, Paypal and Tenpay, default: Alipay.
+ `payment` (required)              - The amount of the payment by customer
+ `subject_text` (optional)         - The subject text of the payment
+ `method` (optional)               - Available methods: paypal, directPay, wechat, default: directPay

Response:

```
Status: 205 Reset Content
```

## Complete an order

Set an order as successfully completed.

```
PUT /orders/completed/:kind/:id
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall

Response:

```
Status: 205 Reset Content
```

## Update memos of an order

Update special_instructions and memo of an order

```
PUT /orders/:kind/:id/memos
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `special_instructions` (optional) - Special instructions of customer
+ `memo` (optional)                 - Memo of customer service

Response:

```
Status: 205 Reset Content
```

## Create an order refund

Create a refund request for an order

```
POST /orders/:kind/:id/refunds
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `merchant_trade_no` (required)    - Merchant trade transaction No.
+ `merchant_refund_id` (required)   - Merchant refund id
+ `amount` (required)               - Refunded money
+ `reason` (optional)               - Refund reason
+ `ship_method` (optional)          - Ship method, e.g EMS, Shunfeng
+ `tracking_number` (optional)      - Shipment tracking number

Response:

```
Status: 201 Created

{
  "order_id": 1,
  "state": "pending",
  "merchant_trade_no": "24898492348230494233",
  "merchant_refund_id": "111932323",
  "amount": 299.0,
  "reason": "货品有问题",
  "ship_method": "EMS",
  "tracking_number": "4928492349343"
}
```

## Agree a refund of an order

Set state of the refund to 'refunded'

```
PUT /orders/:kind/:id/refunds/accepted/:merchant_refund_id
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `merchant_refund_id` (required)   - Merchant refund id
+ `amount` (required)               - Refunded money
+ `reason` (optional)               - Refund reason
+ `ship_method` (optional)          - Ship method, e.g EMS, Shunfeng
+ `tracking_number` (optional)      - Shipment tracking number

Response:

```
Status: 205 Reset Content
```

## Reject an refund of an order

Set state of the refund to 'rejected'

```
PUT /orders/:kind/:id/refunds/rejected/:merchant_refund_id
```

Parameters:

+ `id` (required)                   - Either ID, identifier, or merchant_order_no of the order
+ `kind` (required)                 - Order kind, options are normal, taobao and tmall
+ `merchant_refund_id` (required)   - Merchant refund id

Response:

```
Status: 205 Reset Content
```
