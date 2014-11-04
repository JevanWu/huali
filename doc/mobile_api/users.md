## user sign in 

```
POST /users/sign_in
```
parameters:

+ `email` (optional)                   - email of the user
+ `password` (optional)                - password of the account
+ `uid`(optional)                      - uid of the oauth provider
+ `oauth_provider`(optional)           - the name of the oauth provider
+ `access_token`(optional)             - the access token of the oauth provider
+ `phone`(optional)                    - the phone number of the new user
+ `email`(optional)                    - the email of the new user
+ `name`(optional)                     - the name of the new user

```
status: 200 OK

response example:
{
  authentication_token: "q57hCvkYbNZbWQVLHy6e"
  user_email: user.email,
  user_phone: user.phone,
  user_name: user.name 
}

or

{ new_user: "yes" }
```

## user sign up

```
POST /users
```

parameters:

+ `email` (required)                   - email of the user
+ `password` (required)                - password of the account
+ `name` (required)                    - name of the user
+ `phone` (required)                   - phone number of the user

```
status: 201 Created

response example:
{
  authentication_token: "q57hCvkYbNZbWQVLHy6e"
}
```

## change password

```
PUT /users/chage_password
```

parameters:

+ `password` (required)                - current password
+ `new_password` (required)            - new password
+ `email` (required)                   - Email of the user
+ `token` (required)                   - Authentication token of the user

```
status: 200 OK
```

## change user infomation

```
PUT /users
```

parameters:

+ `name` (required)                   - name of the user
+ `phone` (required)                  - phone number of the user
+ `email` (required)                   - Email of the user
+ `token` (required)                   - Authentication token of the user

```
status: 200 OK
```

## Query huali points of the user

```
GET /users/huali_points
```

parameters:

+ `email` (required)                   - Email of the user
+ `token` (required)                   - Authentication token of the user

```
status: 200 OK

{
  huali_points: 400.0
}
```

## Check the user already exists or not
```
GET /users/exist
```

parameters:

+ `email` (required)                   - Email of the user

```
status: 200 OK

"true"
```

## Send password-reset sms
```
POST /users/password_reset_sms
```

parameters:

+ `email` (required)                   - Email of the user
+ `phone` (required)                   - The phone number which message will be sent to 

```
status: 200 OK
```


## reset the password for user
```
POST /users/reset_password
```

parameters:

+ `email` (required)                   - Email of the user
+ `token` (required)                   - Authentication token of the user
+ `password` (required)                - the new password of the user
+ `reset_token` (required)             - the reset token generated for the user

```
status: 200 OK
```
