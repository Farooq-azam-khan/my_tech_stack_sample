from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

from api.user.routes import router as user_router

app = FastAPI()

frontend_app_port: int = 3000
origins = [f"http://localhost:{frontend_app_port}", f"localhost:3000"]


app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_router)


@app.get("/hw")
def index():
    return "hello world"


@app.get("/")
async def index():
    return {"hello": "world"}


from pydantic import BaseModel
from requests import request
import requests
from dataclasses import dataclass

Password = PasswordHasher()


@dataclass
class Client:
    url: str
    headers: dict

    def run_query(self, query: str, variables: dict, extract=False):
        request = requests.post(
            self.url,
            headers=self.headers,
            json={"query": query, "variables": variables},
        )
        assert request.ok, f"Failed with code {request.status_code}"
        return request.json()

    create_user = lambda self, username, password: self.run_query(
        """
            mutation CreateUser($username: String!, $password: String!) {
                insert_user_one(object: {username: $username, password: $password}) {
                    id
                    username
                    password
                }
            }
        """,
        {"username": username, "password": password},
    )

    find_user_by_username = lambda self, username: self.run_query(
        """
        query UserByUsername($username: String!) {
            user(where: {username: {_eq: $username}}, limit: 1) {
                id
                username
                password
            }
        }
    """,
        {"username": username},
    )

    update_password = lambda self, id, password: self.run_query(
        """
        mutation UpdatePassword($id: Int!, $password: String!) {
            update_user_by_pk(pk_columns: {id: $id}, _set: {password: $password}) {
                password
            }
        }
    """,
        {"id": id, "password": password},
    )


HASURA_URL = "http://graphql-engine:8080/v1/graphql"
HASURA_HEADERS = {"X-Hasura-Admin-Secret": "myadminsecretkey"}
HASURA_JWT_SECRET = "asdf"
client = Client(url=HASURA_URL, headers=HASURA_HEADERS)


class LoginUser(BaseModel):
    username: str
    password: str


class CreateUserOutput(BaseModel):
    id: int
    password: str
    username: str


@app.post("/hasura-jwt-signup")
def handle_jwt_signup(login_data: LoginUser):
    print("from python fastapi:", login_data)
    hashed_password = Password.hash(login_data.password)
    user_response = client.create_user(login_data.username, hashed_password)
    try:

        # happy path
        print("user resposnse:", user_response)
        user = user_response["data"]["insert_user_one"]
        return CreateUserOutput(**user)
    except Exception as e:
        return str(e.message)


class JsonWebToken(BaseModel):
    token: str


import os
import jwt


def rehash_and_save_password_if_needed(user, plaintext_password):
    """
    Whenever your Argon2 parameters – or argon2-cffi’s defaults! –
    change, you should rehash your passwords at the next opportunity.
    The common approach is to do that whenever a user logs in, since
    that should be the only time when you have access to the cleartext password.
    Therefore it’s best practice to check – and if necessary rehash –
    passwords after each successful authentication.
    """
    if Password.check_needs_rehash(user["password"]):
        client.update_password(user["id"], Password.hash(plaintext_password))


# ROLE LOGIC FOR DEMO PURPOSES ONLY
# NOT AT ALL SUITABLE FOR A REAL APP
def generate_token(user) -> str:
    """
    Generates a JWT compliant with the Hasura spec, given a User object with field "id"
    """
    user_roles = ["user"]
    admin_roles = ["user", "admin"]
    # is_admin = user["email"] == "admin@site.com"
    payload = {
        "https://hasura.io/jwt/claims": {
            "x-hasura-allowed-roles": user_roles,
            "x-hasura-default-role": "user",
            "x-hasura-user-id": user["id"],
        }
    }
    token = jwt.encode(payload, HASURA_JWT_SECRET, "HS256")
    return token  # .decode("utf-8")


@app.post("/hasura-jwt-login")
def handle_jwt_login(login_request: LoginUser):
    user_response = client.find_user_by_username(login_request.username)
    try:
        users = user_response["data"]["user"]
        if len(users) == 0:
            raise ValueError("User does not exists")
        if len(users) > 1:
            raise ValueError("huh? Username was not unique")
        user = users[0]
        Password.verify(user.get("password"), login_request.password)
        rehash_and_save_password_if_needed(user, login_request.password)
        return JsonWebToken(token=generate_token(user))
    except VerifyMismatchError:
        return "invalid password"
    except Exception as e:
        return str(e)
