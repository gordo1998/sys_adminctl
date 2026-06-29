#!/bin/bash

_DI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_DI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_DI_LIB/mode/lib_mode_det_mode.sh"
source "$_DI_LIB/dir/validation.sh"
source "$_DI_LIB/dir/execution.sh"
source "$_DI_LIB/log/log.sh"

di_import_dir(){
    local entity=""
    local file_parsed=""
    local root_path=""
    local statement=""

    entity="$1"
    shift
    file_parsed=$(lpd_det_ext "$entity" "import" "$@")
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
