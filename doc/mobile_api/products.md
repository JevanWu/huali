## Query all published products

```
GET /products
```
Parameters:

+ `per_page` (optional)                   - The amount of products presented on each page
+ `page` (optional)                       - The number of page queried

```
Status: 200 OK

[
  { 
    "id": 218, 
    "name_zh": "味爱之旅", 
    "name_en": "love overflows", 
    "inspiration": "远渡重洋而来的永生玫瑰，让盒中充满厄瓜多尔的浪漫空气，绣球与雏菊往其中注入樱花之都的香味；令人心醉的手工巧克力，在唇间融化出法兰西风情，食物与浪漫的完美结合，城市之味与味觉记忆，带你足不出户旅行爱的国度。",
    "maintenance": "请勿浇水或使其潮湿，可能会损坏永生花。勿太阳直晒。",
    "delivery": "本商品仅配送上海城区，具体送达时间以实际物流为准。在您完成支付后，您可以登录后台查看订单以及物流状态，也会接收到短信提示。...",
    "material": "花材：厄瓜多尔永生玫瑰、雏菊、绣球",
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

## Return the products searched
```
GET /search
```
Parameters:

+ `key_word` (required)                   - The Key word for search
+ `per_page` (optional)                   - The amount of products presented on each page
+ `page` (optional)                       - The number of page queried

```
Status: 200 OK

[
  { 
    "id": 218, 
    "name_zh": "味爱之旅", 
    "name_en": "love overflows", 
    "inspiration": "远渡重洋而来的永生玫瑰，让盒中充满厄瓜多尔的浪漫空气，绣球与雏菊往其中注入樱花之都的香味；令人心醉的手工巧克力，在唇间融化出法兰西风情，食物与浪漫的完美结合，城市之味与味觉记忆，带你足不出户旅行爱的国度。",
    "maintenance": "请勿浇水或使其潮湿，可能会损坏永生花。勿太阳直晒。",
    "delivery": "本商品仅配送上海城区，具体送达时间以实际物流为准。在您完成支付后，您可以登录后台查看订单以及物流状态，也会接收到短信提示。...",
    "material": "花材：厄瓜多尔永生玫瑰、雏菊、绣球",
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
  "inspiration": "远渡重洋而来的永生玫瑰，让盒中充满厄瓜多尔的浪漫空气，绣球与雏菊往其中注入樱花之都的香味；令人心醉的手工巧克力，在唇间融化出法兰西风情，食物与浪漫的完美结合，城市之味与味觉记忆，带你足不出户旅行爱的国度。",
  "maintenance": "请勿浇水或使其潮湿，可能会损坏永生花。勿太阳直晒。",
  "delivery": "本商品仅配送上海城区，具体送达时间以实际物流为准。在您完成支付后，您可以登录后台查看订单以及物流状态，也会接收到短信提示。...",
  "material": "花材：厄瓜多尔永生玫瑰、雏菊、绣球",
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
