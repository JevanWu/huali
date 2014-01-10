## Address query

Return the valid address ids combination of `province_id`, `city_id`, `area_id` of a valid address from third-party order system.

```
GET /addresses/ids
```

Parameters:

+ `province` (required)             - Province name
+ `city` (required)                 - City name
+ `area` (optional)                 - District name

```json
{
  "province_id": 1,
  "city_id": 2,
  "area_id": 3
}
