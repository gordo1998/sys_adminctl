#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$LIB_DIR/error/error.sh"

validate_service_format(){
    local service="$1"

    if [[ -z "$service" ]]; then throw_error 100 "servicio"; return $?; fi
    if [[ "$service" == -* ]]; then throw_error 102 "$service"; return $?; fi
    if [[ ! "$service" =~ ^[a-zA-Z0-9_.-]+$ ]]; then throw_error 101 "$service"; return $?; fi

    return 0
}

validate_service_installed(){
    local service="$1"

    if ! dpkg -l "$service" &>/dev/null; then throw_error 201 "$service"; return $?; fi

    return 0
}

validate_service_not_installed(){
    local service="$1"

    if dpkg -l "$service" &>/dev/null; then throw_error 200 "$service"; return $?; fi

    return 0
}

validate_service_active(){
    local service="$1"

    if ! systemctl is-active --quiet "$service"; then throw_error 402 "$service"; return $?; fi

    return 0
}
