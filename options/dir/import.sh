#!/bin/bash

DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/dir/validation.sh"
source "$LIB_DIR/dir/execution.sh"
source "$LIB_DIR/log/log.sh"

di_import_dir(){
    local entity=""
    local file_parsed=""
    local root_path=""
    local statement=""

    entity="$1"
    shift
    file_parsed=$(lpd_det_ext "$entity" "$@")
    root_path=$(lm_det_mode)
    statement=""

    while read -r path;do
        local complete_path="$root_path/$path"
        validate_dir_not_exist "$complete_path"
        statement=$?
        if [[ $statement -eq 0 ]];then
            echo "El directorio completo es: $complete_path"
            execution_dir "$complete_path" && log_action "dir|create|$path"
        else
            return 1
        fi
        

    done <<< "$file_parsed"
}
