import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BIN_DIR = os.path.join(BASE_DIR, "bin")
LOGS_DIR = os.path.join(BASE_DIR, "logs")
SESSION_LOG = os.path.join(LOGS_DIR, "session.log")
UPLOAD_DIR = os.path.join(BASE_DIR, "temporal", "uploads")

SCRIPTS = {
    "user":    os.path.join(BIN_DIR, "userctl.sh"),
    "group":   os.path.join(BIN_DIR, "groupctl.sh"),
    "dir":     os.path.join(BIN_DIR, "dirctl.sh"),
    "service": os.path.join(BIN_DIR, "servictl.sh"),
    "permission": os.path.join(BIN_DIR, "persmissionctl.sh"),
    "admin":   os.path.join(BIN_DIR, "adminctl.sh"),
}

ALLOWED_EXTENSIONS = {"csv", "json", "xml"}

CORS_ORIGINS = "*"

PORT = 5000
DEBUG = False
