import os
import json
import requests
from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from mangum import Mangum

app = FastAPI()

AUTH_URL = "https://auth.aws.eliasbrange.dev"
CLIENT_ID = os.environ["CLIENT_ID"]
REDIRECT_URI = os.environ["REDIRECT_URI"]

@app.get("/")
def login():
    url = f"{AUTH_URL}/authorize?response_type=code&client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}"  # noqa
    return RedirectResponse(url)

@app.get("/callback")
def callback(code: str):
    url = f"{AUTH_URL}/token"
    body = {
        "grant_type": "authorization_code",
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "code": code,
    }

    res = requests.post(url=url, data=body)
    response = json.loads(res.text)

    return {
        "id_token": response["id_token"],
        "access_token": response["access_token"],
    }

handler = Mangum(app)
