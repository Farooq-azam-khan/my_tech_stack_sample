import pytest 
from api.user.schema import (CreateUser, 
                            LoginUser, User, Token
                            )
from pydantic import ValidationError

def test_user_model_creation():
    u = CreateUser(name='name', email='email@email.email', password='password', confirm_password='password')

def test_throws_error_if_passwords_are_not_equal():
    with pytest.raises(ValidationError):
        u = CreateUser(name='name', email='email', password='password', confirm_password='not password')

def test_user_registers_with_valid_email():
    with pytest.raises(ValidationError): 
        u = CreateUser(name='asdf', email='asdf', password='asdf', confirm_password='asdf')

def test_login_user_can_be_created():
    LoginUser(email='asf', password='asdf')

def test_user_model_can_be_created():
    User(id=1, name='asdf', email='asdf@asdf.com', disabled=False)

def test_token_can_be_created():
    Token(access_token='asdf', token_type='asdf')