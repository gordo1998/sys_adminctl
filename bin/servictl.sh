#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../options/service/create.sh"
source "$SCRIPT_DIR/../options/service/delete.sh"
source "$SCRIPT_DIR/../options/service/control.sh"
source "$SCRIPT_DIR/../options/service/import.sh"
source "$SCRIPT_DIR/../options/service/dimport.sh"

COMMAND="$1"
shift

usage(){
cat << EOF

Uso: servictl <comando> [servicio]

Comandos:
    install <service>   Instalar servicio
    remove <service>    Desinstalar servicio
    start <service>     Iniciar servicio
    stop <service>      Parar servicio
    enable <service>    Habilitar servicio
    disable <service>   Deshabilitar servicio
    status <service>    Ver estado del servicio
    import <file>       Instalar servicios desde archivo
    dimport <file>      Desinstalar servicios desde archivo

Opciones:
    --help              Mostrar ayuda
    --version           Mostrar versión

EOF
}

VERSION=$(cat "$SCRIPT_DIR/../version/version")

case "$COMMAND" in
    install)
        sc_install_service "$@"
        ;;
    remove)
        sd_remove_service "$@"
        ;;
    start|stop|enable|disable|status)
        sc_control_service "$COMMAND" "$@"
        ;;
    import)
        si_import_services "$@"
        ;;
    dimport)
        sdi_delete_services "$@"
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
