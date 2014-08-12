## Query all of the orders of current user

```
GET /orders
```

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

## Query an order by the :id

```
GET /orders/:id
```

Parameters:

+ `id` (required)                   - Id of the order 

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
