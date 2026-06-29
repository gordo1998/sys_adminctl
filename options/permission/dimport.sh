#!/bin/bash

PDI_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$PDI_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/parser/detect_extensions/detect_extensions.sh"
source "$LIB_DIR/permission/validation.sh"
source "$LIB_DIR/permission/delete.sh"
source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/log/log.sh"

pdi_delete_permissions(){
    local tipo="$1"
    local file="$2"
    local parsed root_dir

    parsed=$(lpd_det_ext "permission-$tipo" "dimport" "$file")
    root_dir=$(lm_det_mode)

    case "$tipo" in
        acl)
            while IFS="|" read -r dir permiso; do
                acl_delete_validation "$dir" "$permiso" || return 1
                acl_delete "$root_dir/$dir" "$permiso" || return 1
                remove_log_action "permission|acl|$dir|$permiso"
            done <<< "$parsed"
            ;;
        basic)
            while IFS="|" read -r dir permiso; do
                basic_delete_validation "$dir" "$permiso" || return 1
                basic_delete "$root_dir/$dir" "$permiso" || return 1
                remove_log_action "permission|basic|$dir|$permiso"
            done <<< "$parsed"
            ;;
        *)
            echo "Error: tipo de permiso no reconocido para dimport" >&2
            return 1
            ;;
    esac
}
