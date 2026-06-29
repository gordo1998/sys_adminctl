from flask import Blueprint, request, jsonify
from api.utils.file import allowed_extension, save_temp_file, delete_temp_file
from api.utils.parser import parse_file
from api.utils.bash import error_response, success_response

preview_bp = Blueprint("preview", __name__)


@preview_bp.route("/api/preview", methods=["POST"])
def preview():
    if "file" not in request.files:
        return jsonify(error_response(400, "No se ha enviado ningún archivo")), 400

    file = request.files["file"]
    entity_type = request.form.get("type", "")

    if not file.filename:
        return jsonify(error_response(400, "Nombre de archivo vacío")), 400

    if not allowed_extension(file.filename):
        return jsonify(error_response(400, "Extensión no permitida. Usa CSV, JSON o XML")), 400

    if not entity_type:
        return jsonify(error_response(400, "El parámetro 'type' es obligatorio")), 400

    filepath, extension = save_temp_file(file)

    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
        resumen = parse_file(content, extension, entity_type)
        return jsonify(success_response(resumen)), 200
    except ValueError as e:
        return jsonify(error_response(400, str(e))), 400
    except Exception as e:
        return jsonify(error_response(500, f"Error al parsear el archivo: {str(e)}")), 500
    finally:
        delete_temp_file(filepath)
