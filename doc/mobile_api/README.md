# Huali API

## Error messages

All unsuccessfull API requests would return error message as json with following format:

```json
{
  "message": "<main message>",
  "<extra>": "<message>",
  "<extra>": "<other messages>"
}
```

## HTTP Authentication

All API requests require shared key signature. 

If a request with no, or an invalid signature, an error message will be returned with status code 401:

```json
{
  "message": "401 Unauthorized"
}
```

##### The 'Content', 'ContentType', 'Timestamp' and 'Signature' need to be put in the request header

##### The 'Content' is an md5-encrypted code of request body, e.g. "1a79a4d60de6718e8e5b326e338ae533"
##### The 'ContentType' represents the type of the request content, e.g. "text/html"
##### The 'TimeStamp' represents what time the request was sent, e.g. "1410509258"
##### The 'Signature' is an HMAC-SHA1-encrypted code with our private key, the example of encrypted content is "content=CONTENT&content_type=CONTENT_TYPE&path=REQUEST_PATH&timestamp=TIMESTAMP"

Example of a valid API request:

```
GET http://example.com/mobile_api/v1/orders/1
```



## Status codes

The API is designed to return different status codes according to context and action. In this way
if a request results in an error the caller is able to get insight into what went wrong, e.g.
status code `400 Bad Request` is returned if a required attribute is missing from the request.
The following list gives an overview of how the API functions generally behave.

API request types:

* `GET` requests access one or more resources and return the result as JSON
* `POST` requests return `201 Created` if the resource is successfully created and return the newly created resource as JSON
* `GET`, `PUT` and `DELETE` return `200 Ok` if the resource is accessed, modified or deleted successfully, the (modified) result is returned as JSON
* `DELETE` requests are designed to be idempotent, meaning a request a resource still returns `200 Ok` even it was deleted before or is not available. The reasoning behind it is the user is not really interested if the resource existed before or not.


The following list shows the possible return codes for API requests.

Return values:

* `200 Ok` - The `GET`, `PUT` or `DELETE` request was successful, the resource(s) itself is returned as JSON
* `201 Created` - The `POST` request was successful and the resource is returned as JSON
* `400 Bad Request` - A required attribute of the API request is missing, e.g. the title of an issue is not given
* `401 Unauthorized` - The user is not authenticated, a valid user token is necessary, see above
* `403 Forbidden` - The request is not allowed, e.g. the user is not allowed to delete a project
* `404 Not Found` - A resource could not be accessed, e.g. an ID for a resource could not be found
* `405 Method Not Allowed` - The request is not supported
* `409 Conflict` - A conflicting resource already exists, e.g. creating a project with a name that already exists
* `500 Server Error` - While handling the request something went wrong on the server side

## Pagination

When listing resources you can pass the following parameters:

+ `page` (default: `1`) - page number
+ `per_page` (default: `20`, max: `100`) - number of items to list per page

