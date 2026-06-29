#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../config" && pwd)"

source "$LIB_DIR/config.conf"

lm_det_mode(){
	case "$MODE" in
		laboratorio)
				echo "$LAB_ROOT"
			;;
		normal)
				echo "/"
			;;
	esac
}
