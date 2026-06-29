import csv
import json
import xml.etree.ElementTree as ET
from io import StringIO


def parse_file(content: str, extension: str, entity_type: str) -> dict:
    """Parsea el contenido de un archivo y devuelve un resumen estructurado."""
    parsers = {
        "csv":  _parse_csv,
        "json": _parse_json,
        "xml":  _parse_xml,
    }
    parser = parsers.get(extension)
    if not parser:
        raise ValueError(f"Extensión no soportada: {extension}")

    return parser(content, entity_type)


def _parse_csv(content: str, entity_type: str) -> dict:
    result = _empty_result()
    reader = csv.reader(StringIO(content))

    for row in reader:
        row = [col.strip() for col in row if col.strip()]
        if not row:
            continue
        _map_row_to_result(result, entity_type, row)

    return result


def _parse_json(content: str, entity_type: str) -> dict:
    result = _empty_result()
    data = json.loads(content)

    if not isinstance(data, list):
        raise ValueError("El JSON debe ser un array")

    for item in data:
        if isinstance(item, str):
            _map_row_to_result(result, entity_type, [item])
        elif isinstance(item, dict):
            row = list(item.values())
            _map_row_to_result(result, entity_type, row)

    return result


def _parse_xml(content: str, entity_type: str) -> dict:
    result = _empty_result()
    root = ET.fromstring(content)

    for child in root:
        row = list(child.attrib.values())
        if not row:
            row = [child.text.strip()] if child.text else []
        if row:
            _map_row_to_result(result, entity_type, row)

    return result


def _map_row_to_result(result: dict, entity_type: str, row: list) -> None:
    if entity_type == "user" and len(row) >= 1:
        result["usuarios"].append(row[0])
    elif entity_type == "group" and len(row) >= 1:
        result["grupos"].append(row[0])
    elif entity_type == "dir" and len(row) >= 1:
        result["directorios"].append(row[0])
    elif entity_type == "service" and len(row) >= 1:
        result["servicios"].append(row[0])
    elif entity_type.startswith("permission") and len(row) >= 2:
        result["permisos"].append({"dir": row[0], "permiso": row[1]})


def _empty_result() -> dict:
    return {
        "usuarios": [],
        "grupos": [],
        "directorios": [],
        "servicios": [],
        "permisos": []
    }
