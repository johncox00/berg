# Berg

*Dutch for mountain. Yeah, like "ice berg".*

This is a naive API exercise that demonstrates a few concepts:
- Uploading a CSV of `users` through a JSON REST endpoint as a Base64-encoded file.
- Parsing that CSV file asynchronously.
- Ability to check on the status of the parsing (done/not done) and any errors that came from parsing.
- Ability to get a paginated list of `users` using GraphQL.

### Assumptions

1. There was no requirement for uniqueness validation on any `User` fields, so I did not add any. Usually `email` would be unique per user. Not so here.
2. There was an implied requirement for `email` and `phone` to be required fields on `User`, so I did that.
3. Since this is a JSON API, the file upload is handled by requiring the data to be Base64-encoded. Is this 100% necessary? No, but it doesn't add _too_ much overhead and it helps us down the road if we get into binary file uploads.
4. This API requires no authentication nor does it implement any kind of authorization.
5. CSV files have headers.

## Running the app...

- Ruby version 2.6.6
- I used RVM, so if you're using it also, you'll get a new Gemset when you `cd` into the directory.
- Sidekiq is used for asynchronous processing. You'll need Redis to back it.

```
bundle
rails db:migrate
rails s
```

Start the sidekiq worker(s) in a separate terminal window: `bundle exec sidekiq`

## Sample Requests

_Pro tip:_ Use [this](https://onlinecsvtools.com/convert-csv-to-base64) tool to Base64 encode your CSV. You'll then need to prepend `data:text/csv;base64,`.

### Uploading a CSV File

`POST /uploads`

Post body:
```
{
    "upload": {
        "csv": "data:text/csv;base64,Zmlyc3QsbGFzdCxlbWFpbCxwaG9uZQpKb2UsQmxvdyxqb2VAYmxvdy5jb20sODE3LTI4Mi01NjYwCkphbmUsRG9lLGphbmVAZG9lLmNvbSw0NzktNDI2LTM5NTkK"
    }
}
```

Response:
```
{
    "id": 4,
    "csv": {
        "url": "/uploads/upload/csv/4/csv.csv"
    },
    "ready": false,  // indicates if the file has been processed yet
    "errs": [],      // indicates any errors in parsing (errors are ignored and parsing carries on)
    "created_at": "2020-11-17T22:18:31.540Z",
    "updated_at": "2020-11-17T22:18:31.540Z",
    "url": "http://localhost:3000/uploads/4.json"
}
```
### Fetch an Upload

Allows us to see if it's done parsing and any errors that happened in parsing.

`GET /uploads/2`

Response:
```
{
    "id": 2,
    "csv": {
        "url": "/uploads/upload/csv/2/csv.csv"
    },
    "ready": true,
    "errs": [
        {
            "line": [
                [
                    "first",
                    null
                ],
                [
                    "last",
                    "Doe"
                ],
                [
                    "email",
                    "jane"
                ],
                [
                    "phone",
                    "426-3959"
                ]
            ],
            "errors": {
                "email": [
                    "is invalid"
                ],
                "phone": [
                    "is invalid"
                ],
                "first": [
                    "can't be blank"
                ]
            }
        }
    ],
    "created_at": "2020-11-17T21:26:29.006Z",
    "updated_at": "2020-11-17T21:26:29.317Z",
    "url": "http://localhost:3000/uploads/2.json"
}
```

### Fetch Users

Retrieves a paginated list of users with metadata indicating where we are in pagination. Takes arguments for which page to retrieve and desired page size. Default page is 1 and default page size is 20.

`POST /graphql`

Post Body:
```
{ users(page: 12) { currentPage totalPages totalCount results { id first last email phone } } }
```

Response:
```
{
    "data": {
        "users": {
            "currentPage": 12,
            "totalPages": 12,
            "totalCount": 117,
            "results": [
                {
                    "id": "111",
                    "first": "Joe",
                    "last": "Blow",
                    "email": "joe@blow.com",
                    "phone": "(817) 282-5660"
                },
                {
                    "id": "112",
                    "first": "Jane",
                    "last": "Doe",
                    "email": "jane@doe.com",
                    "phone": "(479) 426-3959"
                },
                {
                    "id": "113",
                    "first": "Joe",
                    "last": "Blow",
                    "email": "joe@blow.com",
                    "phone": "(817) 282-5660"
                },
                {
                    "id": "114",
                    "first": "Jane",
                    "last": "Doe",
                    "email": "jane@doe.com",
                    "phone": "(479) 426-3959"
                },
                {
                    "id": "115",
                    "first": "Joe",
                    "last": "Blow",
                    "email": "joe@blow.com",
                    "phone": "(817) 282-5660"
                },
                {
                    "id": "116",
                    "first": "Joe",
                    "last": "Blow",
                    "email": "joe@blow.com",
                    "phone": "(817) 282-5660"
                },
                {
                    "id": "117",
                    "first": "Joe",
                    "last": "Blow",
                    "email": "joe@blow.com",
                    "phone": "(817) 282-5660"
                }
            ]
        }
    }
}
```
