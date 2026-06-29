#!/bin/bash

_UVAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_UVAL_DIR/../error/error.sh"

validate_user_format(){
    local user="$1"

    if [[ -z "$user" ]]; then throw_error 100 "usuario"; return $?; fi
    if [[ "$user" == -* ]]; then throw_error 102 "$user"; return $?; fi
    if [[ ! "$user" =~ ^[a-z0-9_]+$ ]]; then throw_error 101 "$user"; return $?; fi

    return 0
}

validate_user_exist(){
    local user="$1"

    if ! id "$user" &>/dev/null; then throw_error 201 "$user"; return $?; fi

    return 0
}

validate_user_not_exist(){
    local user="$1"

    if id "$user" &>/dev/null; then throw_error 200 "$user"; return $?; fi

    return 0
}
