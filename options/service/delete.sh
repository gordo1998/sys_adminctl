#!/bin/bash

_SD_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_SD_LIB/service/validation.sh"
source "$_SD_LIB/service/execution.sh"

sd_remove_service(){
    local service="$1"

    validate_service_format "$service" || return 1
    validate_service_installed "$service" || return 1

    service_stop "$service" || return 1
    service_disable "$service" || return 1
    service_remove "$service" || return 1
    validate_service_not_installed "$service" || return 1
}
