# my_tech_stack_sample

## Setup 
- setup the server architecture with docker: `docker-compose up`
- setup the hasura migration console: `cd hasura` and `hasura console`
- to run python tests without docker: `cd api` and `poetry run pytest`
- to run python api server without docker: `cd api` and `poetry run uvicorn api.main:app --reload`

## Tech Required to run without Docker 
* python: pip, and poetry 
* node v12 or higher
* hasura cli

## Installations
* hasura cli
* docker
* docker-compose
* node/npm (can install hasura cli with npm as well)


## Features of this tech stack 
* focus on reliability, security, and ease of use
  * secure: all opensource technology (elm, tailwindcss, hasura, postgres) 
  * reliable: graphql is typesafe 
  * easy to use: elm has best compiler error messages, and minimal testing required. if it compiles it works mentality. This is not to say that you don't have to write tests.
* Test first support
* Can extend to a microservice architecture
* postgres db
* token based auth implemented with python fastapi and hasura 
* authorization implemented out of the box with hasura permission
* elm code to handle auth states at the ui level implemented (session storage to store tokens)
* easy stack to collaborate with other
  * hasura migrations automatically tracked which can be checked into source control
  * elm-graphql to fetch graphql types meaning your backend will be synced to the frontend at all times. 
  * (not yet implemented) elm typescript interop in a way that allows you to extend javascript libraries on the client side safely 
* easy routing in the frontend with elm url parser
* global state (i.e. don't need a third party state library)
* utility first styled components 
* typescript interop with elm
* admin / dashboard app fully integrated 

Many of the features listed above are a pain to setup for a project and are eventually required by every project; however, it takes weeks to set it up. For that reason, I created this boilerplate so that the next time you have an idea, download this boilerplate, setup you database models and quickly connect the api to a frontend. The way it is setup with docker allows you to be flexible with the langauge you use on the frontned. I prefer functional based, type safe approach to programming which is why I chose elm. 

For many other they might prefer a javascript based framework like react, vue, svelt, or angular. For those they can do all the setup in the UI folder. Merely have to change the `Docker` file and the way the login flow works on the backend. 

### Cons / future features
* I have not considered the deployment aspects of this. 
* I assume you could use heroku to deploy the database, hasura endpoint, and api and use github pages, aws s3, vercel, etc. to deploy a built version of the UI. 
  * Ask you local devops engineer about the production side of this.
  * Infrastructure as code is also another option here. I've heard good things about Palumi, and Teraform. 
* security in the sense of clean code is addressed; however, security is the aspects of production also is lacking here. Hide the jwt secrets, the hasura admin keys and the postgres database string config. Checkout the following files: `docker-compose.yaml`, `api/main.py`, `hasura/config.yaml`
* If SEO or SSR is a necessary component, good luck. I have given it zero considerations. I think NextJs will be a good help for this. 


### Do as I say not as I do
* do not check in sensitive information 
* do not use int ids for your routing eg. `todos/10`
  * make sure its a random uuid or a slug eg. `todos/asdf`
  * this way hackers do not know any sensative info at the database level


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
10. write a `.env` file in the root of the dir with the env variables from `sample.env`
## Workflow 
apply metadata: `hasura metadata apply` 

## Elm Graphql Codegen
* https://hasura.io/learn/graphql/elm-graphql/elm-graphql/
* can use admin secret or use a dummy user for authorization bearer token   
* potential idea for two elm frontend apps, 1 for admin and 1 for normal users 

## Potential Ideas
* [ ] an admin dashboard 
