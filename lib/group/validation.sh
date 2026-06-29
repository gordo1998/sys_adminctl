#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$LIB_DIR/error/error.sh"

validate_group_format(){
    local group="$1"

    if [[ -z "$group" ]]; then throw_error 100 "grupo"; return $?; fi
    if [[ "$group" == -* ]]; then throw_error 102 "$group"; return $?; fi
    if [[ ! "$group" =~ ^[a-z0-9_]+$ ]]; then throw_error 101 "$group"; return $?; fi

    return 0
}

validate_group_exist(){
    local group="$1"

    if ! getent group "$group" &>/dev/null; then throw_error 201 "$group"; return $?; fi

    return 0
}

validate_group_not_exist(){
    local group="$1"

    if getent group "$group" &>/dev/null; then throw_error 200 "$group"; return $?; fi

    return 0
}
