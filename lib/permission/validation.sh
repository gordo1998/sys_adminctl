#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/error/error.sh"
source "$LIB_DIR/dir/validation.sh"
source "$LIB_DIR/user/validation.sh"
source "$LIB_DIR/group/validation.sh"
source "$LIB_DIR/mode/lib_mode_det_mode.sh"

acl_validation_perm(){
    local permiso="$1"
    local tipo nombre permisos

    IFS=':' read -r tipo nombre permisos <<< "$permiso"

    if [[ -z "$tipo" || -z "$nombre" || -z "$permisos" ]]; then throw_error 102 "usa u:nombre:rwx"; return $?; fi
    if [[ "$tipo" != "u" && "$tipo" != "g" ]]; then throw_error 102 "el tipo debe ser u o g"; return $?; fi
    if [[ ! "$permisos" =~ ^[rwx-]{3}$ ]]; then throw_error 102 "permisos '$permisos' inválidos, usa r, w, x, -"; return $?; fi

    return 0
}

acl_validation(){
    local dir permiso root_dir complete_dir

    dir="$1"
    permiso="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    acl_validation_perm "$permiso" || return $?

    return 0
}

basic_validation_perm(){
    local permiso="$1"

    if [[ -z "$permiso" ]]; then throw_error 100 "permiso"; return $?; fi

    if [[ "$permiso" =~ ^[0-7]{3}$ ]]; then
        return 0
    elif [[ "$permiso" =~ ^[r-][w-][x-][r-][w-][x-][r-][w-][x-]$ ]]; then
        return 0
    else
        throw_error 102 "usa octal (755) o simbólico (rwxr-xr-x)"; return $?
    fi
}

basic_validation(){
    local dir complete_dir root_dir permiso

    dir="$1"
    permiso="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    basic_validation_perm "$permiso" || return $?

    return 0
}

owner_validation(){
    local dir complete_dir root_dir user

    dir="$1"
    user="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    validate_user_exist "$user" || return $?

    return 0
}

acl_delete_validation_perm(){
    local permiso="$1"
    local tipo nombre

    IFS=':' read -r tipo nombre <<< "$permiso"

    if [[ -z "$tipo" || -z "$nombre" ]]; then throw_error 102 "usa u:nombre o g:nombre"; return $?; fi
    if [[ "$tipo" != "u" && "$tipo" != "g" ]]; then throw_error 102 "el tipo debe ser u o g"; return $?; fi

    return 0
}

acl_delete_validation(){
    local dir permiso root_dir complete_dir

    dir="$1"
    permiso="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    acl_delete_validation_perm "$permiso" || return $?

    return 0
}

basic_delete_validation(){
    local dir permiso root_dir complete_dir

    dir="$1"
    permiso="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    basic_validation_perm "$permiso" || return $?

    return 0
}

group_validation(){
    local dir complete_dir root_dir group

    dir="$1"
    group="$2"
    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"

    validate_dir_format "$complete_dir" || return $?
    validate_dir_exist "$complete_dir" || return $?
    validate_group_exist "$group" || return $?

    return 0
}
