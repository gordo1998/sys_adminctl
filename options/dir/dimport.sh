#!/bin/bash

DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/dir/validation.sh"
source "$LIB_DIR/dir/delete.sh"
source "$LIB_DIR/log/log.sh"

ddi_import_dir(){
    local entity=""
    local statement=""
    local root_dir=""
    local complete_dir=""
    local file_parsed=""

    entity="$1"
    shift
    file_parsed=$(lpd_det_ext "$entity" "$@")

    while read -r path;do
        root_dir=$(lm_det_mode)
        complete_dir="$root_dir/$path"
        validate_dir_format "$complete_dir"
        statement=$?
        validate_dir_exist "$complete_dir"
        statement=$?

        if [[ $statement -eq 0 ]];then
            echo "La ruta completa es: $complete_dir"
            delete_dir "$complete_dir" && remove_log_action "dir|create|$path"
        else
            return 1
        fi
    done <<< "$file_parsed"
}