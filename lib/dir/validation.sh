#!/bin/bash

_DVAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_DVAL_DIR/../error/error.sh"

validate_dir_format(){
    local dir="$1"

    if [[ -z "$dir" ]]; then throw_error 103 "ruta vacía"; return $?; fi
    if [[ "$dir" =~ [[:space:]] ]]; then throw_error 103 "espacios en la ruta"; return $?; fi
    if [[ "$dir" != /* ]]; then throw_error 103 "$dir debe empezar por /"; return $?; fi

    [[ "$dir" =~ // ]] && dir="${dir//\/\//\/}"
    return 0
}

validate_dir_not_exist(){
    local dir="$1"

    if [[ -d "$dir" ]]; then throw_error 200 "$dir"; return $?; fi

    return 0
}

validate_dir_exist(){
    local dir="$1"

    if [[ ! -d "$dir" ]]; then throw_error 201 "$dir"; return $?; fi

    return 0
}
