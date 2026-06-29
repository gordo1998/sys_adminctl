#!/bin/bash

csv_permission_acl_parser(){
    local file="$1"

    while IFS="," read -r dir permiso; do
        [[ -z "$dir" || -z "$permiso" ]] && continue
        echo "$dir|$permiso"
    done < "$file"
}

csv_permission_basic_parser(){
    local file="$1"

    while IFS="," read -r dir permiso; do
        [[ -z "$dir" || -z "$permiso" ]] && continue
        echo "$dir|$permiso"
    done < "$file"
}

csv_permission_owner_parser(){
    local file="$1"

    while IFS="," read -r dir user; do
        [[ -z "$dir" || -z "$user" ]] && continue
        echo "$dir|$user"
    done < "$file"
}

csv_permission_group_parser(){
    local file="$1"

    while IFS="," read -r dir group; do
        [[ -z "$dir" || -z "$group" ]] && continue
        echo "$dir|$group"
    done < "$file"
}

csv_permission_acl_delete_parser(){
    local file="$1"

    while IFS="," read -r dir permiso; do
        [[ -z "$dir" || -z "$permiso" ]] && continue
        echo "$dir|$permiso"
    done < "$file"
}

csv_permission_basic_delete_parser(){
    local file="$1"

    while IFS="," read -r dir permiso; do
        [[ -z "$dir" || -z "$permiso" ]] && continue
        echo "$dir|$permiso"
    done < "$file"
}
