#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/log/rollback.sh"

COMMAND="$1"
shift

usage(){
cat << EOF

Uso: adminctl <comando>

Comandos:
    reset       Revertir todo lo creado y limpiar el log

Opciones:
    --help      Mostrar ayuda
    --version   Mostrar versión

EOF
}

VERSION=$(cat "$SCRIPT_DIR/../version/version")

case "$COMMAND" in
    reset)
        rb_rollback
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
