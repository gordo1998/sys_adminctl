#!/bin/bash

declare -A ERROR_MESSAGES

# 1xx - Formato/Validación
ERROR_MESSAGES[100]="campo vacío"
ERROR_MESSAGES[101]="caracteres inválidos"
ERROR_MESSAGES[102]="formato incorrecto"
ERROR_MESSAGES[103]="ruta inválida"

# 2xx - Existencia
ERROR_MESSAGES[200]="ya existe"
ERROR_MESSAGES[201]="no existe"

# 3xx - Ejecución
ERROR_MESSAGES[300]="error al crear"
ERROR_MESSAGES[301]="error al eliminar"
ERROR_MESSAGES[302]="error al modificar"

# 4xx - Sistema
ERROR_MESSAGES[400]="permisos insuficientes"
ERROR_MESSAGES[401]="comando no encontrado"
ERROR_MESSAGES[402]="servicio no disponible"

# 5xx - Configuración
ERROR_MESSAGES[500]="configuración inválida"
ERROR_MESSAGES[501]="modo no reconocido"

throw_error(){
    local code="$1"
    local context="${2:-}"
    local message="${ERROR_MESSAGES[$code]:-error desconocido}"

    if [[ -n "$context" ]]; then
        echo "[ERROR $code] $message: $context" >&2
    else
        echo "[ERROR $code] $message" >&2
    fi

    return "$code"
}
