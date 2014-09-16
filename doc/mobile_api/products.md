## Query all published products

```
GET /products
```
Parameters:

+ `per_page` (optional)                   - The number of products presented on each page
+ `page` (optional)                       - The number of page queried

```
Status: 200 OK

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

## Query a published product by the id

```
GET /products/:id
```

Parameters:

+ `id` (required)                   - Id of a published product

```
Status: 200 OK

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
```
