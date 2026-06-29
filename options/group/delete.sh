#!/bin/bash

_GD_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_GD_LIB/group/validation.sh"
source "$_GD_LIB/group/delete.sh"

gd_delete_group(){
    local group="$1"

    validate_group_format "$group" || return 1
    validate_group_exist "$group" || return 1

    delete_group "$group"
}
