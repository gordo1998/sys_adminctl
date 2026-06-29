#!/bin/bash

UDI_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$UDI_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/parser/detect_extensions/detect_extensions.sh"
source "$LIB_DIR/user/delete.sh"
source "$LIB_DIR/user/validation.sh"
source "$LIB_DIR/log/log.sh"


udi_delete_users(){
	local entity="$1"
	shift
	local parsed=$(lpd_det_ext "$entity" "$@")
	local statement=""
	while read -r user;do
		validate_user_format "$ud_user"
		statement=$?
		validate_user_exist "$ud_user"
		statement=$?

		if [[ $statement -eq 0 ]];then
			echo "Eliminando usuario..."
			delete_user "$ud_user" && remove_log_action "user|create|$ud_user"
		else
			return 1
		fi
		
	done <<<"$parsed"
}


