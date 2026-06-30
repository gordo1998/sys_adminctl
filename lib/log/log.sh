#!/bin/bash

_LOG_SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$(cd "$_LOG_SELF/../../logs" && pwd)/session.log"

log_action(){
    echo "$1" >> "$LOG_FILE"
}

remove_log_action(){
    local entry="$1"
    sed -i "\|^$entry$|d" "$LOG_FILE"
}
