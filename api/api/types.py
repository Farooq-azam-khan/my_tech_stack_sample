from pydantic import BaseModel


class CreateUserOutput(BaseModel):
    id: int
    username: str
    password: str


class SignupUser(BaseModel):
    username: str
    password: str


class LoginUser(BaseModel):
    username: str
    password: str


class JsonWebToken(BaseModel):
    token: str
