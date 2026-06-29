#!/bin/bash

delete_user(){
	local ud_user="$1"

	if sudo userdel -r "$ud_user" &> /dev/null;then
		echo "usuario $ud_user eliminado correctamente"
	else
		echo "El usuario $ud_user no existe o no se ha podido eliminar correctamente"
		return 1
	fi
	
}