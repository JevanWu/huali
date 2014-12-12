## query all provinces

```
get /addresses/provinces
```
Parameters:

+ `product_ids` (required)                   - The ids of the products 

```
status: 200 ok

[
  { 
    "name": "上海市",
  }
  ,
  { 
    "name": "浙江省",
  }
  ,
  ...
]
```

## query all cities of the specified province

```
get /addresses/cities
```

Parameters:

+ `province_id` (required)                       - The id of the province 
+ `product_ids` (required)                       - The ids of the products 

```

```
status: 200 ok

[
  { 
    "name": "杭州市",
  }
  ,
  ...
]
```

## query all areas of the specified city

```
get /addresses/areas
```

Parameters:

+ `city_id` (required)                           - The id of the city 
+ `product_ids` (required)                       - The ids of the products 

```
status: 200 ok

[
  { 
    "name": "浦东新区",
  }
  ,
  ...
]
```
