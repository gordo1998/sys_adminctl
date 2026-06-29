from flask import Flask
from flask_cors import CORS

from api.config import PORT, DEBUG, CORS_ORIGINS
from api.routes.preview import preview_bp
from api.routes.import_routes import import_bp
from api.routes.reset import reset_bp
from api.routes.status import status_bp


def create_app() -> Flask:
    app = Flask(__name__)
    CORS(app, origins=CORS_ORIGINS)

    app.register_blueprint(preview_bp)
    app.register_blueprint(import_bp)
    app.register_blueprint(reset_bp)
    app.register_blueprint(status_bp)

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=PORT, debug=DEBUG)
