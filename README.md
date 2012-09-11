# Site Goal and Introduction
This site is the backend engine to support e-commerce business, it could be able to:

- Display 
  - Display collections of products
  - Display individual product

- Filter and Search
  - Navigate through collections

- Ordering
  - A shopping cart
  - Payment interfaces with Alipay etc

## Rails Environment

## The Design of URLs

### Product Display
`GET /products/:product_name` renders individual product page

`GET /collections/:collection_name` renders collections of products

`GET /pages/:page_name` renders independent pages

`GET /` is alias to `GET /pages/home`

`GET /search?term=` renders collections of search result

### Transaction and Payment

`GET /cart` renders the cart page

`POST /cart/add` add items to cart

`POST /cart/change` update/delete items in cart

## Environment Dependency

`ENV["MANDRILL_USERNAME"]`: mandrill user name
`ENV["MANDRILL_API_KEY"]`: mandrill API key
