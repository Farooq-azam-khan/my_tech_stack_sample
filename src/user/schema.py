from pydantic import BaseModel 

class CreateUser(BaseModel):
  name: str 
  email: str 
  password: str 
  confirm_password: str 

class LoginUser(BaseModel):
  email: str 
  password: str 

class User(BaseModel):
  name: str
  email: str 
