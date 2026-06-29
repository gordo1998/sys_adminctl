#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/group/validation.sh"
source "$LIB_DIR/group/execution.sh"
source "$LIB_DIR/log/log.sh"

gc_create_group(){
    local group="$1"

    validate_group_format "$group" || return 1
    validate_group_not_exist "$group" || return 1

    group_exec_comm "$group" && log_action "group|create|$group"
}
