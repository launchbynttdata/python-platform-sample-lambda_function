import os

PAYLOAD = os.environ.get("PAYLOAD")


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": f"Hello from an ephemeral Python Lambda Function! Payload: {PAYLOAD}",
    }
