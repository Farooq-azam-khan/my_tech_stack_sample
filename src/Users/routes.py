from fastapi import APIRouter 
from schema import LoginUser 

router = APIRouter()

@router.get('/user', tage=['users'])
async def get_user():
  return {'name': 'asdf', 'email': 'asdf@asdf.ca'}

@router.post('/login')
async def login_user(user_creds: LoginUser):
  return {}

@router.post('/logout')
async def logout_user():
  return {}
