from fastapi import APIRouter 
from .schema import LoginUser 

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
