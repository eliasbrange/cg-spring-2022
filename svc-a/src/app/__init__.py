from fastapi import FastAPI
from mangum import Mangum
import os
import boto3

ssm_client = boto3.client("ssm")

table_name = ssm_client.get_parameter(
    Name=os.environ["DYNAMO_TABLE_SSM"]
)["Parameter"]["Value"]

app = FastAPI()


@app.get("/")
def get_root():
    print("test")
    return {"message": f"Hello World {table_name}"}


handler = Mangum(app)
