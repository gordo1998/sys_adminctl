#!/bin/bash

LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../logs" && pwd)"
LOG_FILE="$LOG_DIR/session.log"

log_action(){
    echo "$1" >> "$LOG_FILE"
}

remove_log_action(){
    local entry="$1"
    sed -i "\|^$entry$|d" "$LOG_FILE"
}
