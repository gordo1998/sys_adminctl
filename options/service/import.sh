#!/bin/bash

_SI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_SI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_SI_LIB/service/validation.sh"
source "$_SI_LIB/service/execution.sh"
source "$_SI_LIB/log/log.sh"

si_import_services(){
    local file="$1"
    local parsed

    parsed=$(lpd_det_ext "service" "import" "$file")

    while read -r service; do
        validate_service_format "$service" || return 1
        validate_service_not_installed "$service" || return 1

        service_install "$service" || return 1
        validate_service_installed "$service" || return 1

        service_enable "$service" || return 1
        service_start "$service" || return 1
        validate_service_active "$service" || return 1

        service_disable "$service" || return 1
        log_action "service|install|$service"
    done <<< "$parsed"
}
