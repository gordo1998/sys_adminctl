#!/bin/bash

_SC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_SC_LIB/service/validation.sh"
source "$_SC_LIB/service/execution.sh"
source "$_SC_LIB/log/log.sh"

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
