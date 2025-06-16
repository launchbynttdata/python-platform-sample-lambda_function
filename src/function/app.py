import os

PAYLOAD = os.environ.get("PAYLOAD")


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": f"Hello from a sample Python Lambda Function! Payload: {PAYLOAD}",
    }
