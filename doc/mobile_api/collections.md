## Query all collections of products

```
GET /collections
```

```
Status: 200 OK

Response example:
[
  { 
    "id": 1,
    "name_zh": "节日", 
    "name_en": "Festival",
    "description": "Festival", 
    "priority": 1, 
    "children_collections":
      [ 
        { 
          "id": 2,
          "name_zh": "情人节", 
          "name_en": "Valentine's day",
          "description": "Valentine's day", 
          "priority": 1, 
          "children_collections": nil
        }
        ,
        ...
      ]
  }
  ,
  ...
]
```
