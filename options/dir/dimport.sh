#!/bin/bash

_DDI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_DDI_LIB/mode/lib_mode_det_mode.sh"
source "$_DDI_LIB/dir/validation.sh"
source "$_DDI_LIB/dir/delete.sh"
source "$_DDI_LIB/log/log.sh"

ddi_import_dir(){
    local entity=""
    local statement=""
    local root_dir=""
    local complete_dir=""
    local file_parsed=""

    entity="$1"
    shift
    file_parsed=$(lpd_det_ext "$entity" "dimport" "$@")

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