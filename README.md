# my_tech_stack_sample

## Backend Python/FastAPI
- You can see the backend code in `/api`. 
- `cd api/`
- To run the tests: `poetry run pytest`
- To run the app in dev mode: `poetry run uvicorn api.main:app --reload` 
- `docker-compose up`

## Features
* type safe and reliable programming with elm and Python
* focus on reliability, security, and ease of use
* Test first support
* postgres db
* token based auth
* graphql with hasura


## How records in PG will be stored
*  slug UUID + pk Integer Auto Increment Unique Not Null
    * slug for unique client side identification
    * pk for primary key indexing 

# Hasura setup migrations
- https://hasura.io/docs/latest/graphql/core/migrations/migrations-setup.html#migrations-setup
- step by step
1. hasura init
2. cd in hasura folder
3. put admin_secret in config.yml file
4. create initial migrtion: `hasura migrate create "init" --from-server --database-name [name of database in hasura (i called it dev)]`
5. the created migrations have been applied thus apply them: `haura migrate apply --version "version that came when step 4 was executed" --skip-execution` --database-name dev

## Elm Graphql Codegen
* https://hasura.io/learn/graphql/elm-graphql/elm-graphql/
* can use admin secret or use a dummy user for authorization bearer token   
* potential idea for two elm frontend apps, 1 for admin and 1 for normal users 