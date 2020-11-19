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
5. CSV files have headers. Assumes headers to be 'first', 'last', 'email', 'phone', but allows for those headers to be any case (ex. 'first' or 'First' or 'FIRST').

### CI

I went ahead and set up Code Climate for code quality and CircleCI for automating tests. You can find the Code Climate page [here](https://codeclimate.com/github/johncox00/berg). If you run tests locally, you can see the coverage report in `/coverage/index.html`.

### Running the App Using Docker && Docker Compose

If you have Docker on your machine and don't want to worry with the particulars of any dependencies, you can run this app using `docker-compose`. In this scenario, you'll end up with containers running Redis, PostgreSQL, Sidekiq, and the Rails web server. If you'd rather run the app locally, skip to the next section.

First time through:

```
cd ~/yourdir/berg # the directory the app was cloned into
docker-compose up --build
```

Time to grab a cup of coffee. The build will take a bit the first time through - particularly installing the `bundle` in the app container. (Don't worry, it's super fast to start after the first time.) Once it's up, you should be able to hit the API at `localhost:3000`. The server runs in `dev` mode for the sake of this exercise. Details on the API can be found below.

After you're done playing with the app, you can `ctrl+c` to shut it down. Then the next time you want to start it up:

```
docker-compose up
```

## Running the App Locally

- Ruby version 2.6.6
- I used RVM, so if you're using it also, you'll get a new Gemset when you `cd` into the directory.
- Sidekiq is used for asynchronous processing. You'll need Redis to back it.
- PostgreSQL database. I started with SQLite for simplicity, but introduced Postgres in the process of spinning up the Docker implementation.

Assuming you already have Postgres running, set up the database:

```
sudo -u postgres psql
postgres=# create database berg_db;
postgres=# create user the_berg with encrypted password 'berg_pw';
postgres=# grant all privileges on database berg_db to the_berg;
```

Get the app set up:

```
gem install bundler
bundle
yarn install --check-files
rails db:migrate
```

Start the Sidekiq worker(s) in a separate terminal window:

```
bundle exec sidekiq
```

Run the tests:

```
rspec
```

Run the web server:

```
rails s
```


## Sample Requests

If you'd like to try the API out using Postman, [here's a collection](https://www.getpostman.com/collections/4dfb6f707b2d46d6d1e1) to get you started.

_Pro tip:_ Use [this](https://onlinecsvtools.com/convert-csv-to-base64) tool to Base64 encode your CSV. You'll then need to prepend `data:text/csv;base64,`.

*Uploading a CSV File*

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
*Fetch an Upload*

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

*Fetch Users*

Retrieves a paginated list of users with metadata indicating where we are in pagination. Takes arguments for which page to retrieve and desired page size. Default page is 1 and default page size is 20.

Worth noting: Attributes/fields that are specified as `snake_case` in code are required to be requested as and will return as `cammelCase`. For instance, the field `created_at` would be requested at `createdAt` and would be returned the same. (This was a new development)

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
