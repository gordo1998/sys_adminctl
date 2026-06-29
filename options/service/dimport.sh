#!/bin/bash

_SDI_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_SDI_LIB/parser/detect_extensions/detect_extensions.sh"
source "$_SDI_LIB/service/validation.sh"
source "$_SDI_LIB/service/execution.sh"
source "$_SDI_LIB/log/log.sh"

sdi_delete_services(){
    local file="$1"
    local parsed

    parsed=$(lpd_det_ext "service" "dimport" "$file")

    while read -r service; do
        validate_service_format "$service" || return 1
        validate_service_installed "$service" || return 1

        service_stop "$service" || return 1
        service_disable "$service" || return 1
        service_remove "$service" || return 1
        validate_service_not_installed "$service" || return 1
        remove_log_action "service|install|$service"
    done <<< "$parsed"
}
