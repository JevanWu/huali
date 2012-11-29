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
### Ruby on Rails

This application requires:

* Ruby version 1.9.3
* Rails version 3.2.8

Learn more about "Installing Rails":http://railsapps.github.com/installing-rails.html.

### Database

This application uses PostgreSQL with ActiveRecord.

### Development

* Template Engine: ERB
* Testing Framework: RSpec and Factory Girl and Cucumber
* Front-end Framework: Normalized CSS
* Form Builder: Formtastic
* Authentication: Devise
* Authorization: None

### Email

The application is configured to send email using a Mandrill account.

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

### Admin Panel
`GET /admin/:model` to access the model management panel

## Environment Dependency

`ENV["MANDRILL_USERNAME"]`: mandrill user name
`ENV["MANDRILL_API_KEY"]`: mandrill API key

## Test Strategy
Model Spec is used to do test on:
  - model dependencies
  - data validations
  - before, after hooks
  - business logic

Request Spec is used to do end-to-end test. It tests the APIs exposed to the client. It includes:

  - routing testing
  - state actions(cookie, token etc.)
  - response

Feature Spec *will be* used to make end-to-end test simulating user behavior.

Helper Spec is used to test helper methods.

Some specs are not included in the projects because:
  - Routing Spec: the `route.rb` is well tested in the Rails projects.
  - Controller Spec: use end-to-end test is more close to the user scenario.
  - View Spec: will be covered in Feature Spec.
