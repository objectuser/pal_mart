# PalMart

## Running

```sh
mix deps.get
mix ecto.setup
mix phx.server
```

See the "Sample data" section for using the API with some sample data.

Alternatively, there is a LiveBook under `notebooks`. It may be run using the
"Mix Standalone" mode of operation.

```sh
mix escript.install hex livebook
livebook server --name livebook@127.0.0.1
```

## Testing

```sh
mix test
```

## Discussion

### Approach

PalMart is driven through a RESTful API.

Users may register for the service, at which time the user account is credited
with 100 minutes of available visitation.

I chose an API-driven solution because I thought a UI would take a lot of time
with little relative value.

The main API endpoints are:
- `/api/v1/users` - supporting user registration
- `/api/v1/visits` - supporting requesting a visit as a member and accepting a
  visit as a pal, as well as listing all available visits

The API endpoints are sparse and could use to be fleshed out a bit more. For
example, a user's visits might be under `/api/v1/users/:id/visits`. There's
generally a lot more than can be done there.

The system uses a SQLite3 for convenience of setup and review of the solution.

### Schema

I varied from the schema with respect to the `transactions`.

I considered the transasctions to be a per-user ledger, with each debit and
credit being recorded per user

I recorded the user's initial balance in the ledger as well, so that computing
the balance was a simple summation across all transactions in a user's ledger.

### Validation

I used `Ecto.Changeset` support for  schemaless changesets in the controllers in
order to cast values and minimally validate the requests.

### Security

I did not do anything for security due to time limits. This means that anyone
can request a visit on behalf of a user, for example.

Further, this means that a user may accept the same request made by that user.

[Broken access control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)

### Testing

This could use more and better test coverage, especially around failure paths
and parameter validation.

### Miscellaneous

- I consdidered doing more folder organization (by grouiping related concepts).
  However, with so few modules I decided a flat structure was fine.
- I started to add `@spec`s to functions, but ran out of time.
- There is often a lot of chaff when using `phx.new`, which could be cleaned up.
  For example, the default is now to setup LiveView, which I didn't use here.

## Sample data

The following `curl` commands may be used to test the functionality through the
API.

```sh
curl -X POST -H 'Content-Type: application/json' localhost:4000/api/v1/users -d '{
  "first_name": "User",
  "last_name": "One",
  "email": "user.one@example.com"
}'

curl -X POST -H 'Content-Type: application/json' localhost:4000/api/v1/users -d '{
  "first_name": "User",
  "last_name": "Two",
  "email": "user.two@example.com"
}'

curl -X POST -H 'Content-Type: application/json' localhost:4000/api/v1/visits -d '{
  "member_id": 1,
  "date": "2022-02-16",
  "minutes": 60,
  "tasks": "Grocery run"
}'

curl -X PUT -H 'Content-Type: application/json' localhost:4000/api/v1/visits/1 -d '{
  "pal_id": 2
}'

# Denied
curl -X POST -H 'Content-Type: application/json' localhost:4000/api/v1/visits -d '{
  "member_id": 1,
  "date": "2022-02-16",
  "minutes": 60,
  "tasks": "Grocery run"
}'

# List of visits for user ID 1
curl -X GET -H 'Content-Type: application/json' localhost:4000/api/v1/visits/1
```
