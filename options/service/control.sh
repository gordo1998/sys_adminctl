#!/bin/bash

SCTL_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCTL_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/service/validation.sh"
source "$LIB_DIR/service/execution.sh"

sc_control_service(){
    local action="$1"
    local service="$2"

    validate_service_format "$service" || return 1
    validate_service_installed "$service" || return 1

    case "$action" in
        start)
            service_start "$service" || return 1
            validate_service_active "$service" || return 1
            ;;
        stop)
            service_stop "$service" || return 1
            ;;
        enable)
            service_enable "$service" || return 1
            ;;
        disable)
            service_disable "$service" || return 1
            ;;
        status)
            service_status "$service"
            ;;
        *)
            echo "Error: acción no reconocida" >&2
            return 1
            ;;
    esac
}
