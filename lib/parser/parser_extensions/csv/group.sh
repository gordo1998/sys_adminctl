#!/bin/bash

csv_group_parser(){
    local file="$1"

    while read -r group; do
        [[ -z "$group" ]] && continue
        echo "$group"
    done < "$file"
}

csv_group_delete_parser(){
    local file="$1"

    while read -r group; do
        [[ -z "$group" ]] && continue
        echo "$group"
    done < "$file"
}
