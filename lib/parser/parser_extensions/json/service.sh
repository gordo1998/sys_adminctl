#!/bin/bash

_JSVC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)/lib"
source "$_JSVC_LIB/error/error.sh"

json_service_parser(){
    local file="$1"

    if ! command -v jq &>/dev/null; then throw_error 401 "jq no instalado"; return $?; fi

    jq -r '.[]' "$file"
}

json_service_delete_parser(){
    local file="$1"

    if ! command -v jq &>/dev/null; then throw_error 401 "jq no instalado"; return $?; fi

    jq -r '.[]' "$file"
}
