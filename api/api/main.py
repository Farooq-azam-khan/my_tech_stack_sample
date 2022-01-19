from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

from api.client import Client
from api.types import CreateUserOutput, SignupUser, LoginUser, JsonWebToken

import jwt


app = FastAPI()

frontend_app_port: int = 3000
origins = [f"http://localhost:{frontend_app_port}", f"localhost:3000"]

HASURA_URL = "http://graphql-engine:8080/v1/graphql"
HASURA_HEADERS = {"X-Hasura-Admin-Secret": "myadminsecretkey"}
HASURA_JWT_SECRET = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
client = Client(url=HASURA_URL, headers=HASURA_HEADERS)
Password = PasswordHasher()

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from pydantic import BaseModel


class SignupInput(BaseModel):
    input: SignupUser


@app.post("/hasura-jwt-signup")
def handle_jwt_signup(signup_info: SignupInput):
    signup_info = signup_info.input
    print("from python fastapi:", signup_info.username)
    hashed_password = Password.hash(signup_info.password)
    user_response = client.create_user(signup_info.username, hashed_password)
    try:

        # happy path
        # print("user resposnse:", user_response)
        user = user_response["data"]["insert_user_one"]
        return CreateUserOutput(**user)
    except Exception as e:
        return str(e.message)


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
            "x-hasura-user-id": str(user["id"]),
        }
    }
    token = jwt.encode(payload, HASURA_JWT_SECRET, "HS256")
    return token  # .decode("utf-8")


class LoginUserInput(BaseModel):
    input: LoginUser


@app.post("/hasura-jwt-login")
def handle_jwt_login(login_request: LoginUserInput):
    login_request = login_request.input
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


@app.get("/hello-world")
def index():
    return {"hello": "world"}
