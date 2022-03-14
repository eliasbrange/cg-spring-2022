def handler(event, context):
    request = event["Records"][0]["cf"]
    print(request)
