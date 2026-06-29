#!/bin/bash

_PD_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_PD_LIB/permission/validation.sh"
source "$_PD_LIB/permission/delete.sh"
source "$_PD_LIB/mode/lib_mode_det_mode.sh"

dir_perm_delete(){
    local dir complete_dir root_dir permiso

    case "$1" in
        -a|--acl)
            shift
            dir="$1"
            permiso="$2"
            acl_delete_validation "$dir" "$permiso" || return 1
            root_dir=$(lm_det_mode)
            complete_dir="$root_dir/$dir"
            acl_delete "$complete_dir" "$permiso" || return 1
            ;;
        -b|--basic)
            shift
            dir="$1"
            permiso="$2"
            basic_delete_validation "$dir" "$permiso" || return 1
            root_dir=$(lm_det_mode)
            complete_dir="$root_dir/$dir"
            basic_delete "$complete_dir" "$permiso" || return 1
            ;;
        *)
            echo "Error: tipo de permiso no reconocido" >&2
            return 1
            ;;
    esac
}
