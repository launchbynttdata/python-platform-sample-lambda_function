from function import app


def test_primary_handler():
    result = app.lambda_handler(None, None)
    assert result["statusCode"] == 200
    assert result["body"] == "Hello from a sample Python Lambda!"


def test_alternate_handler():
    result = app.alternate_lambda_handler(None, None)
    assert result["statusCode"] == 200
    assert result["body"] == "Hello from a different sample Python Lambda!"
