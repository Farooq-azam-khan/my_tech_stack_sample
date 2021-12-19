# standard lib imports
from datetime import datetime, timedelta

# thrid party import
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

from jose import JWTError, jwt

from passlib.context import CryptContext


# custom imports
from .schema import Token, TokenData, User, UserInDB

# to get a string like this run:
# openssl rand -hex 32
# TODO: hide them in a .env folder
SECRET_KEY = "xyz"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

router = APIRouter(
  prefix='/user', 
  tags=['user'], 
  dependencies=[], 
  responses={404: {'description': 'Not Found'}}
)

@router.get('/user', tags=['users'])
async def get_user():
  return {'name': 'asdf', 'email': 'asdf@asdf.ca'}

@router.post('/login')
async def login_user(_: LoginUser):
  return {}

@router.post('/logout')
async def logout_user():
  return {}
