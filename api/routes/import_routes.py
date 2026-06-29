from flask import Blueprint, request, jsonify
from api.utils.file import allowed_extension, save_temp_file, delete_temp_file
from api.utils.bash import run_script, error_response, success_response
from api.config import SCRIPTS

import_bp = Blueprint("import", __name__)

ENTITY_SCRIPT_MAP = {
    "user":             "user",
    "group":            "group",
    "dir":              "dir",
    "service":          "service",
    "permission-acl":   "permission",
    "permission-basic": "permission",
    "permission-owner": "permission",
    "permission-group": "permission",
}


def _run_import(command: str):
    if "file" not in request.files:
        return jsonify(error_response(400, "No se ha enviado ningún archivo")), 400

    file = request.files["file"]
    entity_type = request.form.get("type", "")

    if not file.filename:
        return jsonify(error_response(400, "Nombre de archivo vacío")), 400

    if not allowed_extension(file.filename):
        return jsonify(error_response(400, "Extensión no permitida. Usa CSV, JSON o XML")), 400

    if not entity_type or entity_type not in ENTITY_SCRIPT_MAP:
        return jsonify(error_response(400, f"Tipo de entidad inválido: '{entity_type}'")), 400

    script_key = ENTITY_SCRIPT_MAP[entity_type]
    script = SCRIPTS.get(script_key)

    filepath, _ = save_temp_file(file)

    try:
        if entity_type.startswith("permission-"):
            tipo_perm = entity_type.split("-", 1)[1]
            resultado = run_script(script, [command, tipo_perm, filepath])
        else:
            resultado = run_script(script, [command, filepath])

        if resultado["exit_code"] != 0:
            return jsonify(error_response(500, resultado["error"] or resultado["output"])), 500

        return jsonify(success_response({"output": resultado["output"]})), 200
    except Exception as e:
        return jsonify(error_response(500, str(e))), 500
    finally:
        delete_temp_file(filepath)


@import_bp.route("/api/import", methods=["POST"])
def import_file():
    return _run_import("import")


@import_bp.route("/api/dimport", methods=["POST"])
def dimport_file():
    return _run_import("dimport")
