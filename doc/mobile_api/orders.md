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

+ Json:
      order_info: {
        sender_name: "...",
        sender_email: "...",
        sender_phone: "...",
        coupon_code: "...",
        gift_card_text: "...",
        special_instructions: "...",
        memo: "...",
        ship_method_id: "...",
        expected_date: "...",
        delivery_date: "...",
        receiver_fullname: "...",
        receiver_phone: "...",
        receiver_province_id: "...",
        receiver_city_id: "...",
        receiver_area_id: "...",
        receiver_post_code: "...",
        receiver_address: "...",
        products: [
                    { product_id: "...", price: "...", quantity: "..." },
                    ...
                  ]
       
      }

+ `email` (required)                  - Email of the user
+ `token` (required)                  - Authentication token of the user

```
Status: 201 Created

{ 
  state: "wait_confirm",
  total: "499.0",
  payment_total: "499.0",
  identifier: "OR1410280001",
  expected_date: "2014-10-24",
  receiver_fullname: "...",
  receiver_address: "...",
  receiver_phone: "18521302300",
  receiver_post_code: "200120",
  products: [ 
              { name_zh: "...", name_en: "...", quantity: 1 },
              ...
            ]        
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
