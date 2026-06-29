#!/bin/bash

acl_execution(){
    local dir permiso
    
    dir="$1"
    permiso="$2"

    sudo setfacl -m "$permiso" "$dir" || return 1
    
    return 0
}

basic_execution(){
    local dir permiso

    dir="$1"
    permiso="$2"

    sudo chmod "$permiso" "$dir" || return 1

    return 0
}

owner_execution(){
    local dir user

    dir="$1"
    user="$2"

    sudo chown "$dir" "$user" || return 1

    return 0
}

group_execution(){
    local dir group

    dir="$1"
    group="$2"

    sudo chown ":$group" "$dir" || return 1

    return 0
}