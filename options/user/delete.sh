#!/bin/bash

SCRIPT_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/user/validation.sh"
source "$LIB_DIR/user/delete.sh"



ud_dmake_user(){
	
	local ud_user="$1"
	local statement=""

	validate_user_format "$ud_user"
	statement=$?
	validate_user_exist "$ud_user"
	statement=$?


	if [[ $statement -eq 0 ]];then
		echo "Eliminando usuario..."
		delete_user "$ud_user"
	else
		return 1
	fi

}




