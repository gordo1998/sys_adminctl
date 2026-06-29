#!/bin/bash

SD_DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SD_DIR_SOURCE/../../lib" && pwd)"

source "$LIB_DIR/service/validation.sh"
source "$LIB_DIR/service/execution.sh"

sd_remove_service(){
    local service="$1"

    validate_service_format "$service" || return 1
    validate_service_installed "$service" || return 1

    service_stop "$service" || return 1
    service_disable "$service" || return 1
    service_remove "$service" || return 1
    validate_service_not_installed "$service" || return 1
}
