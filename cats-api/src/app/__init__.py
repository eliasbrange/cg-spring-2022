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


class Cat(BaseModel):
    id: int
    name: str


@app.get("/cats/{cat_id}", response_model=Cat, tags=["cats"])
def get_cat(cat_id):
    try:
        return dynamo.get_item("cat", cat_id)
    except dynamo.ItemNotFoundError:
        raise HTTPException(status_code=404, detail="Cat not found")


@app.get("/cats", response_model=List[Cat], tags=["cats"])
def get_cats():
    return dynamo.list_items("cat")


@app.post("/cats", status_code=201, tags=["cats"])
def post_cat(data: Cat):
    try:
        return dynamo.post_item("cat", data.id, data.name)
    except dynamo.ItemAlreadyExistsError:
        raise HTTPException(status_code=409, detail="Cat already exists")


@app.delete("/cats/{cat_id}", status_code=204, tags=["cats"])
def delete_cat(cat_id):
    try:
        return dynamo.delete_item("cat", cat_id)
    except dynamo.ItemNotFoundError:
        raise HTTPException(status_code=404, detail="Cat not found")


handler = Mangum(app)
