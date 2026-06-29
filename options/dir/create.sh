#!/bin/bash

_DC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_DC_LIB/mode/lib_mode_det_mode.sh"
source "$_DC_LIB/dir/validation.sh"
source "$_DC_LIB/dir/execution.sh"
source "$_DC_LIB/log/log.sh"

dc_create_dir(){
    local dir="$1"
    local dir_root="$(lm_det_mode)"
    local complete_dir="$dir_root/$dir"
    validate_dir_exist "$complete_dir"
    local dir_not_exist=$?

    if [ $dir_not_exist -eq 0 ]; then
        echo "El directorio completo es: $complete_dir"
        execution_dir "$complete_dir" && log_action "dir|create|$dir"
    else
        return 1
    fi
}
