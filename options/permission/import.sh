#!/bin/bash

_PI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_PI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_PI_LIB/permission/validation.sh"
source "$_PI_LIB/permission/execution.sh"
source "$_PI_LIB/mode/lib_mode_det_mode.sh"
source "$_PI_LIB/log/log.sh"

pi_import_permissions(){
    local tipo="$1"
    local file="$2"
    local parsed root_dir

    parsed=$(lpd_det_ext "permission-$tipo" "import" "$file")
    root_dir=$(lm_det_mode)

    case "$tipo" in
        acl)
            while IFS="|" read -r dir permiso; do
                acl_validation "$dir" "$permiso" || return 1
                acl_execution "$root_dir/$dir" "$permiso" || return 1
                log_action "permission|acl|$dir|$permiso"
            done <<< "$parsed"
            ;;
        basic)
            while IFS="|" read -r dir permiso; do
                basic_validation "$dir" "$permiso" || return 1
                basic_execution "$root_dir/$dir" "$permiso" || return 1
                log_action "permission|basic|$dir|$permiso"
            done <<< "$parsed"
            ;;
        owner)
            while IFS="|" read -r dir user; do
                owner_validation "$dir" "$user" || return 1
                owner_execution "$root_dir/$dir" "$user" || return 1
                log_action "permission|owner|$dir|$user"
            done <<< "$parsed"
            ;;
        group)
            while IFS="|" read -r dir group; do
                group_validation "$dir" "$group" || return 1
                group_execution "$root_dir/$dir" "$group" || return 1
                log_action "permission|group|$dir|$group"
            done <<< "$parsed"
            ;;
        *)
            echo "Error: tipo de permiso no reconocido" >&2
            return 1
            ;;
    esac
}
