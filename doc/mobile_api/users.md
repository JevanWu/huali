## user sign in 

```
post /users/sign_in
```
parameters:

+ `email` (required)                   - email of the user
+ `password` (required)                - password of the account

```
status: 200 OK

response example:
{
  authentication_token: "q57hCvkYbNZbWQVLHy6e"
}
```

## user sign up

```
post /users/sign_up
```

parameters:

+ `email` (required)                   - email of the user
+ `password` (required)                - password of the account
+ `name` (required)                    - name of the user
+ `phone` (required)                   - phone number of the user

```
status: 201 Created
```
