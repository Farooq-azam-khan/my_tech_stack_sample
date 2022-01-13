from pydantic import BaseModel, ValidationError, validator, EmailStr
from typing import Optional


class CreateUser(BaseModel):
    name: str
    email: EmailStr
    password: str
    confirm_password: str

    @validator("confirm_password")
    def passwords_match(cls, v, values):
        password = values["password"]
        if password != v:
            raise ValidationError("Passwords do not match")
        return v


# class LoginUser(BaseModel):
#   email: EmailStr
#   password: str


class User(BaseModel):
    id: int
    name: str
    email: EmailStr
    disabled: bool = False


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    name: Optional[str] = None


class UserInDB(User):
    hashed_password: str
