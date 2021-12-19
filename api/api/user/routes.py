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
