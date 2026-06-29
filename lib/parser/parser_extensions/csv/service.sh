#!/bin/bash

csv_service_parser(){
    local file="$1"

    while read -r service; do
        [[ -z "$service" ]] && continue
        echo "$service"
    done < "$file"
}

csv_service_delete_parser(){
    local file="$1"

    while read -r service; do
        [[ -z "$service" ]] && continue
        echo "$service"
    done < "$file"
}
