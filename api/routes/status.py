from flask import Blueprint, jsonify
from api.utils.bash import error_response, success_response
from api.config import SESSION_LOG
import os

status_bp = Blueprint("status", __name__)


def _parse_log() -> dict:
    """Lee session.log y agrupa las entidades creadas por tipo."""
    estado = {
        "usuarios": [],
        "grupos": [],
        "directorios": [],
        "servicios": [],
        "permisos": []
    }

    if not os.path.exists(SESSION_LOG):
        return estado

    with open(SESSION_LOG, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split("|")
            if len(parts) < 3:
                continue

            tipo, _, arg1 = parts[0], parts[1], parts[2]

            if tipo == "user":
                estado["usuarios"].append(arg1)
            elif tipo == "group":
                estado["grupos"].append(arg1)
            elif tipo == "dir":
                estado["directorios"].append(arg1)
            elif tipo == "service":
                estado["servicios"].append(arg1)
            elif tipo == "permission":
                entry = {"dir": arg1, "permiso": parts[3] if len(parts) > 3 else ""}
                estado["permisos"].append(entry)

    return estado


@status_bp.route("/api/status", methods=["GET"])
def status():
    try:
        estado = _parse_log()
        return jsonify(success_response(estado)), 200
    except Exception as e:
        return jsonify(error_response(500, str(e))), 500
