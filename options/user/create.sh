#!/bin/bash


_UC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_UC_LIB/mode/lib_mode_det_mode.sh"
source "$_UC_LIB/user/validation.sh"
source "$_UC_LIB/user/execution.sh"
source "$_UC_LIB/log/log.sh"


#ESTA FUNCIÓN VALIDARÁ EL PARÁMETRO
uc_det_param(){
	local user=""
	local dir_par=""
	local statement=""

	while [[ $# -gt 0 ]];do
		case "$1" in
			--dir)
				dir_par="$2"
				shift 2
				;;
			-*)
				echo "Error: Opción no reconocida '$1'"
				return 1
				;;
			*)
				user="$1"
				shift
				;;
		esac
	done

	validate_user_format "$user" || return 1
	validate_user_not_exist "$user" || return 1
	
	echo "$user|$dir_par|0" 
}

uc_create_user(){
	local dir_root=$(lm_det_mode)
	local complete_dir=""
	
	IFS='|' read -r user dir_par statement <<< "$(uc_det_param "$@")"
	complete_dir="$dir_root/$dir_par"
	
	if [[ $statement -eq 0 ]];then
		echo "El usuario es: $user"
		echo "El directorio personal es: $dir_root"
		#Llamamos a la funcion de ejecucion  que se encuentra en la libreria
		user_exec_comm "$user" "$complete_dir" && log_action "user|create|$user"
	else
		return 1
	fi
	
}

