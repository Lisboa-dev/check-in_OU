import base64
import hashlib
import hmac
import io
import os

import qrcode

QR_SECRET = os.getenv("QR_SECRET", "qr-secret-change-me")
BASE_VALIDATION_URL = os.getenv("BASE_VALIDATION_URL", "https://checkin.local/validate")


def build_qr_payload(form_id: int, user_id: int) -> str:
    raw = f"{form_id}:{user_id}"
    signature = hmac.new(QR_SECRET.encode(), raw.encode(), hashlib.sha256).hexdigest()
    return f"{BASE_VALIDATION_URL}?f={form_id}&u={user_id}&sig={signature}"


def validate_qr_payload(payload: str, form_id: int, user_id: int) -> bool:
    expected = build_qr_payload(form_id=form_id, user_id=user_id)
    return hmac.compare_digest(payload, expected)


def generate_qr_base64(payload: str) -> str:
    image = qrcode.make(payload)
    buffer = io.BytesIO()
    image.save(buffer, format="PNG")
    encoded = base64.b64encode(buffer.getvalue()).decode("utf-8")
    return encoded
