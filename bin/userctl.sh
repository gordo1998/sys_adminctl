#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../options/user/create.sh"
source "$SCRIPT_DIR/../options/user/delete.sh"
source "$SCRIPT_DIR/../options/user/import.sh"
source "$SCRIPT_DIR/../options/user/dimport.sh"

USERCTL_COMMAND="$1"

usage(){
cat << EOF

Uso: userctl <comando> [opciones]

Comandos:
	create <user>	Crear usuario
	delete <user>	Eliminar usuario
	import <file>	Crear usuarios desde archivo
	dimport <file>	Eliminar usuarios desde archivo

Opciones:
	--dir			Definir directorio de trabajo del usuario
	--help			Mostrar ayuda
	--version		Mostrar versión

EOF
}

VERSION=$(cat "../version/version")

case "$USERCTL_COMMAND" in
	create)
		shift
		uc_create_user "$@"
		;;
	delete)
		shift
		ud_delete_user "$@"
		;;
	import)
		shift
		ui_import_users "user" "$@"
		;;
	dimport)
		shift
		udi_delete_users "user" "$@"
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
