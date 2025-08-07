from unittest.mock import patch

from function import app


def test_primary_handler():
    result = app.lambda_handler(None, None)
    assert result["statusCode"] == 200
    assert "Payload: None" in result["body"]


def test_primary_handler_with_payload():
    with patch.object(app, "PAYLOAD", "test_payload"):
        result = app.lambda_handler(None, None)
        assert result["statusCode"] == 200
        assert "test_payload" in result["body"]
