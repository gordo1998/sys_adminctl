#!/bin/bash

acl_execution(){
    local dir permiso
    
    dir="$1"
    permiso="$2"

    setfacl -m "$permiso" "$dir" || return 1
    
    return 0
}

basic_execution(){
    local dir permiso

    dir="$1"
    permiso="$2"

    chmod "$permiso" "$dir" || return 1

    return 0
}

owner_execution(){
    local dir user

    dir="$1"
    user="$2"

    chown "$dir" "$user" || return 1

    return 0
}

group_execution(){
    local dir group

    dir="$1"
    group="$2"

    chown ":$group" "$dir" || return 1

    return 0
}