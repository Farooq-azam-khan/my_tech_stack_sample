from pydantic import BaseModel 
from typing import Optional

class CreateUser(BaseModel):
  name: str 
  email: str 
  password: str 
  confirm_password: str 

class LoginUser(BaseModel):
  email: str 
  password: str 

class User(BaseModel):
  id: int 
  name: str
  email: str 
  disabled: bool = False 


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    name: Optional[str] = None


class UserInDB(User):
    hashed_password: str
    