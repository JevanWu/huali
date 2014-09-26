## The Billing Modules
Billing Modules are responsible for the communication for different billing gateways.

It **takes in an transaction** which agrees on [some attributes](#agreed-attributes) and does two kinds of jobs:
- generate the **provider-specific** and **valid** url to complete the payment.
- process the return(GET) or notify(POST) request as a query string, perform verification and return the result object containing the this transaction information.

## Components
`Gateway` contains the module to generate request string from a transaction.

`Return` contains the module to process the return GET request.

`Notify` contains the module to process the notify POST request.

## Agreed-Attributes on Transactoin
The transaction object used to communicate with the library should contain at least this attributes

```ruby
{
  paymethod: "[paypal alipay bankPay wechat wechat_mobile]"
  identifier: 'used to identifier the transaction' # required
  amount: 'amount to be paid in RMB' # required
  subject: 'the summary about the products' # required
  body: 'the full description about the products'
  merchant_name: 'to determine the bank used in bankPay method'
}
```
