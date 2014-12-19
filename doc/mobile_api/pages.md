## Query all enabled static pages

```
GET /pages
```

```
Status: 200 OK

Response example:
[
  { 
    "id": 1, 
    "title_zh": "关于我们", 
    "title_en": "About Us",
    "content_zh": "关于我们页面内容", 
    "content_en": "The content of 'About us' page", 
    "permalink": "/about_us" 
  }
  ,
  { 
    "id": 2,
    "title_zh": "联系我们", 
    "title_en": "Contact Us",
    "content_zh": "联系我们页面内容", 
    "content_en": "The content of 'Contact us' page", 
    "permalink": "/about_us" 
  }
]
```
