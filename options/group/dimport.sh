#!/bin/bash

_GDI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_GDI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_GDI_LIB/group/validation.sh"
source "$_GDI_LIB/group/delete.sh"
source "$_GDI_LIB/log/log.sh"

gdi_delete_groups(){
    local entity="$1"
    shift
    local gdi_parsed=$(lpd_det_ext "$entity" "dimport" "$@")

    while read -r group; do
        validate_group_format "$group" || return 1
        validate_group_exist "$group" || return 1
        delete_group "$group" || return 1
        remove_log_action "group|create|$group"
    done <<< "$gdi_parsed"
}
