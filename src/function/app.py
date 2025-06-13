def lambda_handler(event, context):
    return {"statusCode": 200, "body": "Hello from a sample Python Lambda!"}


def alternate_lambda_handler(event, context):
    return {"statusCode": 200, "body": "Hello from a different sample Python Lambda!"}
