#!/bin/bash

csv_dir_parser(){
    local file="$1"

    while read -r path;do
        echo "$path"
    done < "$file"
}

csv_dir_delete_parser(){
    local file="$1"

    while read -r path;do
        echo "$path"
    done < "$file"
}

