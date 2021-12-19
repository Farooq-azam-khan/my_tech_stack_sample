from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware


# from app.user.routes import router as user_router

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

# app.include_router(user_router)

@app.get('/')
def index(): 
    return {'hello': 'world'}
