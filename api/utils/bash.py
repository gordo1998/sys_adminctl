import subprocess
from api.config import BIN_DIR


def run_script(script_path: str, args: list) -> dict:
    """Ejecuta un script Bash y devuelve exit_code, stdout y stderr."""
    try:
        resultado = subprocess.run(
            [script_path] + args,
            capture_output=True,
            text=True,
            cwd=BIN_DIR
        )
        return {
            "exit_code": resultado.returncode,
            "output": resultado.stdout.strip(),
            "error": resultado.stderr.strip()
        }
    except FileNotFoundError:
        return {
            "exit_code": 1,
            "output": "",
            "error": f"Script no encontrado: {script_path}"
        }
    except Exception as e:
        return {
            "exit_code": 1,
            "output": "",
            "error": str(e)
        }


def success_response(data: dict) -> dict:
    return {"success": True, "data": data, "error": None}


def error_response(code: int, message: str) -> dict:
    return {"success": False, "data": None, "error": {"code": code, "message": message}}
