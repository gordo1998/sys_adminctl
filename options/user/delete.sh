#!/bin/bash

_UD_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_UD_LIB/mode/lib_mode_det_mode.sh"
source "$_UD_LIB/user/validation.sh"
source "$_UD_LIB/user/delete.sh"



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




