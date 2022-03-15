from aws_lambda_powertools import Logger

logger = Logger(service="payment")


DOMAINS = [
    {
        "path": "/cats",
        "domain": "cats.aws.eliasbrange.dev",
    },
    {
        "path": "/dogs",
        "domain": "dogs.aws.eliasbrange.dev",
    },
]


@logger.inject_lambda_context
def handler(event, context):
    request = event["Records"][0]["cf"]["request"]
    logger.info("Request received", extra=request)

    uri = request["uri"]

    for d in DOMAINS:
        if uri.startswith(d["path"]):
            request["origin"]["custom"]["domainName"] = d["domain"]
            host = [{"key": "host", "value": d["domain"]}]
            request["headers"]["host"] = host
            break
    else:
        return {
            "status": 404,
            "statusDescription": "Not Found",
        }

    logger.info("Request returned", extra=request)
    return request
