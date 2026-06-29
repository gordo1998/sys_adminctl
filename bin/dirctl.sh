#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../options/dir/create.sh"
source "$SCRIPT_DIR/../options/dir/delete.sh"
source "$SCRIPT_DIR/../options/dir/import.sh"
source "$SCRIPT_DIR/../options/dir/dimport.sh"


COMMAND="$1"

usage(){
cat << EOF

Uso: userctl <comando> [opciones]

Comandos:
	create <user>	Crear directorio
	delete <user>	Eliminar directorio
	import <file>	Crear directorios desde archivo
	dimport <file>	Eliminar directorios desde archivo

Opciones:
	--help			Mostrar ayuda
	--version		Mostrar versión

EOF
}

VERSION=$(cat "../version/version")

case "$COMMAND" in
	create)
		shift
		dc_create_dir "$@"
		;;
	delete)
		shift
		dd_delete_dir "$@"
		#FUNCION ARCHIVO DELETE
		;;
	import)
		shift
		di_import_dir "dir" "$@"
		#FUNCION ARCHIVO IMPORT
		;;
	dimport)
		ddi_import_dir "dir" "$@"
		#FUNCION ARCHIVO DIMPORT
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
