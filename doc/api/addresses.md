## Address query

Return the valid address ids combination of `province_id`, `city_id`, `area_id` of a valid address from third-party order system.

```
GET /addresses/ids
```

Parameters:

+ `province` (required)             - Province name
+ `city` (optional)                 - City name
+ `area` (optional)                 - District name

One of the two optional parameters `city` and `area` must be present, or it raises a invalid parameter error


```json
{
  "province_id": 1,
  "city_id": 2,
  "area_id": 3
}
