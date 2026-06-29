#!/bin/bash

_UDI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_UDI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_UDI_LIB/user/delete.sh"
source "$_UDI_LIB/user/validation.sh"
source "$_UDI_LIB/log/log.sh"


udi_delete_users(){
	local entity="$1"
	shift
	local parsed=$(lpd_det_ext "$entity" "dimport" "$@")
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


