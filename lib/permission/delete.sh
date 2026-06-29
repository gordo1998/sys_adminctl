#!/bin/bash

acl_delete(){
    local dir permiso

    dir="$1"
    permiso="$2"

    setfacl -x "$permiso" "$dir" || return 1

    return 0
}

basic_delete(){
    local dir permiso

    dir="$1"
    permiso="$2"

    chmod "$permiso" "$dir" || return 1

    return 0
}
