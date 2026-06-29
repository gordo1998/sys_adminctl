#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../options/permission/create.sh"
source "$SCRIPT_DIR/../options/permission/delete.sh"
source "$SCRIPT_DIR/../options/permission/import.sh"
source "$SCRIPT_DIR/../options/permission/dimport.sh"

COMMAND="$1"
shift

usage(){
cat << EOF

Uso: userctl <comando> [opciones]

Comandos:
	create <user>	Crear permiso
	delete <user>	Eliminar permiso
	import <file>	Crear permisos desde archivo
	dimport <file>	Eliminar permisos desde archivo

Opciones:
	-a | --acl 				Define permisos acl
	-b | --basic			Define permisos básicos
	-o | --owner			Define el propietario de un archivo
	-g | --group			Define el grupo de un archivo
	--help			Mostrar ayuda
	--version		Mostrar versión

EOF
}

VERSION=$(cat "$SCRIPT_DIR/../version/version")

case "$COMMAND" in
	create)
		dir_perm "$@"
		;;
	delete)
		dir_perm_delete "$@"
		;;
	import)
		pi_import_permissions "$@"
		;;
	dimport)
		pdi_delete_permissions "$@"
		;;
	-h|--help)
		usage
		exit 0
		;;
	-v|--version)
		echo "$VERSION"
		exit 0
		;;
	*)
		echo "Opcion no válida"
		exit 1
		;;
esac
