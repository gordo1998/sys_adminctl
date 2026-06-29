#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/group/validation.sh"
source "$LIB_DIR/group/delete.sh"

gd_delete_group(){
    local group="$1"

    validate_group_format "$group" || return 1
    validate_group_exist "$group" || return 1

    delete_group "$group"
}
