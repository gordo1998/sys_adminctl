#!/bin/bash

_GI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_GI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_GI_LIB/group/validation.sh"
source "$_GI_LIB/group/execution.sh"
source "$_GI_LIB/log/log.sh"

gi_import_groups(){
    local entity="$1"
    shift
    local gi_parsed=$(lpd_det_ext "$entity" "import" "$@")

    while read -r group; do
        validate_group_format "$group" || return 1
        validate_group_not_exist "$group" || return 1
        group_exec_comm "$group" || return 1
        log_action "group|create|$group"
    done <<< "$gi_parsed"
}
