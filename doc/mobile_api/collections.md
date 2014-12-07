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

## Query all products of a collection

```
GET /collections/:id/products
```

Parameters:

+ `id` (required)                   - Id of the collection

```
Status: 200 OK

Response example:
[
  { 
    "id": 218, 
    "name_zh": "味爱之旅", 
    "name_en": "love overflows", 
    "description": "###花艺师手记<span> INSPIRATION</span>......", 
    "count_on_hand": 100, 
    "price": 499.0, 
    "height": 24.0, 
    "width": 24.0, 
    "depth": 5.0, 
    "priority": 63,
    "product_type": "preserved_flower", 
    "images": 
      [
        {
          image_file_name: "1.jpg",
          full: "/system/assets/images/000/001/009/original/1.jpg?1406693540",
          medium: "/system/assets/images/000/001/009/medium/1.jpg?1406693540",
          small: "/system/assets/images/000/001/009/small/1.jpg?1406693540",
          thumb: "/system/assets/images/000/001/009/thumb/1.jpg?1406693540"
        }
        ,
        ...
      ]
  }
  ,
  ...
]
```
