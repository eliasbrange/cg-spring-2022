from typing import List
from fastapi import FastAPI, HTTPException
from mangum import Mangum
from . import dynamo
from pydantic import BaseModel

app = FastAPI()


@app.get("/")
def get_root():
    print("test")
    return {"message": "Hello World"}


class Dog(BaseModel):
    id: int
    name: str


@app.get("/dogs/{dog_id}", response_model=Dog, tags=["dogs"])
def get_dog(dog_id):
    try:
        return dynamo.get_item("dog", dog_id)
    except dynamo.ItemNotFoundError:
        raise HTTPException(status_code=404, detail="Dog not found")


@app.get("/dogs", response_model=List[Dog], tags=["dogs"])
def get_dogs():
    return dynamo.list_items("dog")


@app.post("/dogs", status_code=201, tags=["dogs"])
def post_dog(data: Dog):
    try:
        return dynamo.post_item("dog", data.id, data.name)
    except dynamo.ItemAlreadyExistsError:
        raise HTTPException(status_code=409, detail="Dog already exists")


@app.delete("/dogs/{dog_id}", status_code=204, tags=["dogs"])
def delete_dog(dog_id):
    try:
        return dynamo.delete_item("dog", dog_id)
    except dynamo.ItemNotFoundError:
        raise HTTPException(status_code=404, detail="Dog not found")


handler = Mangum(app)
