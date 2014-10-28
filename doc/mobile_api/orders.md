## Query all of the orders of current user

```
GET /orders
```

Parameters:

+ `email` (required)                   - Email of the user
+ `token` (required)                   - Authentication token of the user
+ `per_page` (optional)                   - The amount of orders presented on each page
+ `page` (optional)                       - The number of page queried

```
Status: 200 OK

Response example:
[
  {
    "id": 13156, 
    "identifier": "OR1408050007", 
    "item_total": 1099.0,
    "total": 1099.0,
    "payment_total": 0.0, 
    "state": "generated", 
    "address": "河滨路海普家苑4号楼二单元2405号", 
    "gift_card_text": "永远爱你!", 
    "expected_date": "2014-08-07", 
    "sender_email": "jindagongju@163.com", 
    "sender_phone": "+86 18267687777", 
    "sender_name": "刘建敏", 
    "delivery_date": nil, 
    "adjustment": nil,
    "ship_method": nil, 
    "kind": "normal", 
    "subject_text": "亲密关系(永生花) x 1"
  }
  ,
  ...
]
 
```

## Query an order by the :id or :identifier

```
GET /orders/query
```

Parameters:

+ `id` (optional)                     - The id of the order 
+ `identifier` (optional)             - The identifier of the order 
+ `email` (required)                  - Email of the user
+ `token` (required)                  - Authentication token of the user

```
Status: 200 OK

{
  "id": 13156, 
  "identifier": "OR1408050007", 
  "item_total": 1099.0,
  "total": 1099.0,
  "payment_total": 0.0, 
  "state": "generated", 
  "special_instructions": "I need ...", 
  "address": "河滨路海普家苑4号楼二单元2405号", 
  "user": order.user.name, 
  "gift_card_text": "永远爱你!", 
  "expected_date": "2014-08-07", 
  "sender_email": "jindagongju@163.com", 
  "sender_phone": "+86 18267687777", 
  "sender_name": "刘建敏", 
  "delivery_date": nil, 
  "adjustment": nil,
  "ship_method": nil, 
  "kind": "normal", 
  "subject_text": "亲密关系(永生花) x 1"
}
```

## Create an order

```
POST /orders
```

Parameters:

+ `sender_name` (optional)            - Sender name
+ `sender_email` (optional)           - Sender email
+ `sender_phone` (optional)           - Sender phone
+ `coupon_code` (optional)            - Coupon code
+ `gift_card_text` (optional)         - Gift card text
+ `special_instructions` (optional)   - Customer memo
+ `memo` (optional)                   - Customer service memo
+ `kind` (required)                   - Order kind, options are normal, taobao and tmall
+ `merchant_order_no` (required)      - Merchant order No.
+ `ship_method_id` (optional)         - EMS: 4, 人工: 3, 顺风: 2, 联邦: 1, 申通: 5
+ `expected_date` (optional)          - Expected arrival date
+ `delivery_date` (optional)          - Delivery date
+ `receiver_fullname` (required)      - Receiver fullname
+ `receiver_phone` (required)         - Receiver phone
+ `receiver_province_id` (required)   - Receiver province id
+ `receiver_city_id` (required)       - Receiver city id
+ `receiver_area_id` (optional)       - Receiver area(district) id
+ `receiver_post_code` (optional)     - Receiver post code
+ `receiver_address` (required)       - Receiver address

+ `email` (required)                  - Email of the user
+ `token` (required)                  - Authentication token of the user

```
Status: 201 Created
```

## Create line items for an order

```
POST /orders/:id/line_items
```

Parameters:

+ `id` (required)                     - Either ID, identifier, or merchant_order_no of the order
+ `product_id` (required)             - Order line item product id
+ `price` (required)                  - product price
+ `quantity` (required)               - Order line item product quantity

+ `email` (required)                  - Email of the user
+ `token` (required)                  - Authentication token of the user
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

## Cancel an order

```
PUT /orders/:id/cancel
```

Parameters:

+ `id` (required)                     - Id of the order

+ `email` (required)                  - Email of the user
+ `token` (required)                  - Authentication token of the user

```
Status: 200 OK
```
