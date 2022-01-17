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

# Hasura migrations and metadata workflow

## Setup 
1. `hasura init hasura --endpoint http:graphql-engine:8080`
2. `cd hasura`
3. put `admin_secret:??` in `config.yml` file
4. create initial migrtion from a hasura client currently running: `hasura migrate create "init" --from-server --database-name [name of database in hasura (i called it dev)]`
5. the created migrations have been applied thus apply them: `haura migrate apply --version "version that came when step 4 was executed" --skip-execution --database-name dev` (step might not be neede)
6. apply the metadata changes `hasura metadata apply`
7. update the docker compose of the graphql app to (with your env vars of course). 
```YAML
graphql-engine:
    image: hasura/graphql-engine:v2.0.10.cli-migrations-v3
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - api
    restart: always
    volumes:
      - ./hasura/migrations:/hasura-migrations
      - ./hasura/metadata:/hasura-metadata
    environment:
      ## postgres database to store Hasura metadata
      HASURA_GRAPHQL_METADATA_DATABASE_URL: postgres://postgres:postgres@postgres:5432/postgres
      ## this env var can be used to add the above postgres database to Hasura as a data source. this can be removed/updated based on your needs
      PG_DATABASE_URL: postgres://postgres:postgres@postgres:5432/postgres
      ## enable the console served by server
      HASURA_GRAPHQL_ENABLE_CONSOLE: "false" # set to "false" to disable console
      ## enable debugging mode. It is recommended to disable this in production
      HASURA_GRAPHQL_DEV_MODE: "true"
      HASURA_GRAPHQL_ENABLED_LOG_TYPES: startup, http-log, webhook-log, websocket-log, query-log
      ## uncomment next line to set an admin secret
      HASURA_GRAPHQL_ADMIN_SECRET: myadminsecretkey
      HASURA_GRAPHQL_JWT_SECRET: '{"type":"HS256", "key":
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "claims_format": "json"}'
      HASURA_GRAPHQL_UNAUTHORIZED_ROLE: "anonymous"
```
8. start up the engine: `cd ..` and `docker-compose up`
9. start up the hasura console: `cd hasura`, `hasura console`
- any migration level changes will automatically be applied
- any metdata level changes (like permission, action, events, etc.) will need to be added by you
## Workflow 
apply metadata: `hasura metadata apply` 

## Elm Graphql Codegen
* https://hasura.io/learn/graphql/elm-graphql/elm-graphql/
* can use admin secret or use a dummy user for authorization bearer token   
* potential idea for two elm frontend apps, 1 for admin and 1 for normal users 

## Installations
* hasura cli
* docker
* docker-compose
* node/npm