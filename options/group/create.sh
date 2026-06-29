#!/bin/bash

_GC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_GC_LIB/group/validation.sh"
source "$_GC_LIB/group/execution.sh"
source "$_GC_LIB/log/log.sh"

gc_create_group(){
    local group="$1"

    validate_group_format "$group" || return 1
    validate_group_not_exist "$group" || return 1

    group_exec_comm "$group" && log_action "group|create|$group"
}
