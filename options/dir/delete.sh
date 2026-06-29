#!/bin/bash

DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/dir/validation.sh"
source "$LIB_DIR/dir/delete.sh"

dd_delete_dir(){
    local dir=""
    local statement=""
    local root_dir=""
    local complete_dir=""

    root_dir=$(lm_det_mode)
    complete_dir="$root_dir/$dir"
    validate_dir_format "$complete_dir"
    statement=$?
    validate_dir_exist "$complete_dir"
    statement=$?

    if [[ $statement -eq 0 ]];then
        echo "La ruta completa es: $complete_dir"
        delete_dir "$complete_dir"
    else
        return 1
    fi

}