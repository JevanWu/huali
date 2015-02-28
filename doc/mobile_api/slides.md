## query all enabled slides

```
get /slides
```

```
status: 200 ok

[
  { 
    "id": 1,
    "name": "七夕",
    "href": "/qixi",
    "priority": 5,
    "image": "/system/assets/images/000/001/009/thumb/1.jpg?14065l3340"
  }
  ,
  { 
    "id": 2,
    "name": "母亲节",
    "href": "/muqinjie",
    "priority": 6,
    "image": "/system/assets/images/000/001/009/thumb/1.jpg?1406663530"
  }
]
```

## query a slide by the :id

```
post /slides/:id
```

parameters:

+ `id` (required)                   - id of the slide

```
status: 200 ok

{ 
  "id": 1,
  "name": "七夕",
  "href": "/qixi",
  "priority": 5,
  "image": "/system/assets/images/000/001/009/thumb/1.jpg?14065l3340"
}
```
