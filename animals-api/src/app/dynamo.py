import os
import boto3
from boto3.dynamodb.conditions import Attr, Key


table = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])


class Error(Exception):
    pass


class ItemAlreadyExistsError(Error):
    pass


class ItemNotFoundError(Error):
    pass


def post_item(animal, animal_id, value):
    try:
        table.put_item(
            Item={
                "PK": animal,
                "SK": str(animal_id),
                "Name": value,
            },
            ConditionExpression=Attr("PK").not_exists(),
        )
    except table.meta.client.exceptions.ConditionalCheckFailedException:
        raise ItemAlreadyExistsError


def list_items(animal):
    res = table.query(
        KeyConditionExpression=Key("PK").eq(animal)
    )

    return [
        {
            "id": a["SK"],
            "name": a["Name"],
        } for a in res["Items"]
    ]


def get_item(animal, animal_id):
    res = table.get_item(
        Key={
            "PK": animal,
            "SK": animal_id,
        },
    )

    item = res.get("Item")
    if not item:
        raise ItemNotFoundError

    return {
        "id": item["SK"],
        "name": item["Name"],
    }


def delete_item(animal, animal_id):
    try:
        table.delete_item(
            Key={
                "PK": animal,
                "SK": animal_id,
            },
            ConditionExpression=Attr("PK").exists(),
        )
    except table.meta.client.exceptions.ConditionalCheckFailedException:
        raise ItemNotFoundError
