#!/bin/bash

UI_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$UI_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/parser/detect_extensions/detect_extensions.sh"
source "$LIB_DIR/mode/lib_mode_det_mode.sh"
source "$LIB_DIR/user/execution.sh"
source "$LIB_DIR/user/validation.sh"
source "$LIB_DIR/log/log.sh"

#EN BASE A LA LISTA PARSEADA DE UI_PARSED EJECUTA LAS INSTRUCCIONES PARA LA CREACIÓN DE USUARIOS
ui_import_users(){

	local entity="$1"
	shift
	#ESTA VARIABLE SE ENCARGA DE RECOGER LA LISTA PARSEADA.
	local ui_parsed=$(lpd_det_ext "$entity" "$@")
	#ESTA DETECTA EL MODO DEL ENTORNO (LABORATORIO O NORMAL PARA CREAR EL PATH RAIZ)
	local ui_dir=$(lm_det_mode)
	local statement=""

	while IFS="|" read -r user path_user;do
		local complete_dir="$ui_dir/$path_user"

		validate_user_format "$user"
		statement=$?
		validate_user_not_exist "$user"
		statement=$?

		if [[ $statement -eq 0 ]];then
			echo "El usuario es: $user"
			echo "El directorio personal es: $complete_dir"
			#Llamamos a la funcion de ejecucion  que se encuentra en la libreria
			user_exec_comm "$user" "$complete_dir" && log_action "user|create|$user"
		else
			return 1
		fi
	done <<< "$ui_parsed"
}
