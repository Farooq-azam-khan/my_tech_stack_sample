from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from typing import List 
from pydantic import BaseModel 
import pandas as pd 

app = FastAPI()

frontend_app_port: int = 3000 
origins = [
    f'http://localhost:{frontend_app_port}',
    f'localhost:3000'
]



app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*']
)

@app.get('/')
def index(): 
    
    return {'hello': 'world'}
