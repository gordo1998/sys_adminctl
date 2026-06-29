#!/bin/bash

SC_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SC_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/service/validation.sh"
source "$LIB_DIR/service/execution.sh"
source "$LIB_DIR/log/log.sh"

sc_install_service(){
    local service="$1"

    validate_service_format "$service" || return 1
    validate_service_not_installed "$service" || return 1

    service_install "$service" || return 1
    validate_service_installed "$service" || return 1

    service_enable "$service" || return 1
    service_start "$service" || return 1
    validate_service_active "$service" || return 1

    service_disable "$service" || return 1

    log_action "service|install|$service"
}
