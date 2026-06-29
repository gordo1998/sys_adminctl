#!/bin/bash

GDI_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$GDI_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/parser/detect_extensions/detect_extensions.sh"
source "$LIB_DIR/group/validation.sh"
source "$LIB_DIR/group/delete.sh"
source "$LIB_DIR/log/log.sh"

gdi_delete_groups(){
    local entity="$1"
    shift
    local gdi_parsed=$(lpd_det_ext "$entity" "$@")

    while read -r group; do
        validate_group_format "$group" || return 1
        validate_group_exist "$group" || return 1
        delete_group "$group" || return 1
        remove_log_action "group|create|$group"
    done <<< "$gdi_parsed"
}
