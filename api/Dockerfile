# pull base image
FROM python:3.9
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /api/ 
# Install dependencies 
RUN pip install poetry 
COPY poetry.lock pyproject.toml /api/ 
RUN poetry install 
EXPOSE 8000 
COPY ./api  /api/
CMD ["poetry", "run", "uvicorn", "api.main:app", "--host", "0.0.0.0", "--reload"]