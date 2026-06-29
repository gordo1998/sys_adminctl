#!/bin/bash

SI_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SI_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/parser/detect_extensions/detect_extensions.sh"
source "$LIB_DIR/service/validation.sh"
source "$LIB_DIR/service/execution.sh"
source "$LIB_DIR/log/log.sh"

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
