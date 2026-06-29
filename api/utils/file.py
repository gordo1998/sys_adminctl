import os
import uuid
from werkzeug.datastructures import FileStorage
from api.config import UPLOAD_DIR, ALLOWED_EXTENSIONS


def allowed_extension(filename: str) -> bool:
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def save_temp_file(file: FileStorage) -> tuple[str, str]:
    """Guarda el archivo temporalmente. Devuelve (ruta, extensión)."""
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    extension = file.filename.rsplit(".", 1)[1].lower()
    filename = f"{uuid.uuid4().hex}.{extension}"
    filepath = os.path.join(UPLOAD_DIR, filename)
    file.save(filepath)
    return filepath, extension


def delete_temp_file(filepath: str) -> None:
    try:
        os.remove(filepath)
    except OSError:
        pass
