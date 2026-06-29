#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)/lib"

source "$LIB_DIR/error/error.sh"

json_group_parser(){
    local file="$1"

    if ! command -v jq &>/dev/null; then throw_error 401 "jq no instalado"; return $?; fi

    jq -r '.[]' "$file"
}

json_group_delete_parser(){
    local file="$1"

    if ! command -v jq &>/dev/null; then throw_error 401 "jq no instalado"; return $?; fi

    jq -r '.[]' "$file"
}
