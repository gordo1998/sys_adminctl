from flask import Blueprint, jsonify
from api.utils.bash import run_script, error_response, success_response
from api.config import SCRIPTS

reset_bp = Blueprint("reset", __name__)


@reset_bp.route("/api/reset", methods=["POST"])
def reset():
    resultado = run_script(SCRIPTS["admin"], ["reset"])

    if resultado["exit_code"] != 0:
        return jsonify(error_response(500, resultado["error"] or resultado["output"])), 500

    return jsonify(success_response({"output": resultado["output"]})), 200
