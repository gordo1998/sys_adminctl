#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../options/group/create.sh"
source "$SCRIPT_DIR/../options/group/delete.sh"
source "$SCRIPT_DIR/../options/group/import.sh"
source "$SCRIPT_DIR/../options/group/dimport.sh"

COMMAND="$1"
shift

usage(){
cat << EOF

Uso: groupctl <comando> [opciones]

Comandos:
    create <group>      Crear grupo
    delete <group>      Eliminar grupo
    import <file>       Crear grupos desde archivo
    dimport <file>      Eliminar grupos desde archivo

Opciones:
    --help              Mostrar ayuda
    --version           Mostrar versión

EOF
}

VERSION=$(cat "$SCRIPT_DIR/../version/version")

case "$COMMAND" in
    create)
        gc_create_group "$@"
        ;;
    delete)
        gd_delete_group "$@"
        ;;
    import)
        gi_import_groups "group" "$@"
        ;;
    dimport)
        gdi_delete_groups "group" "$@"
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
        echo "Opción no válida"
        exit 1
        ;;
esac
