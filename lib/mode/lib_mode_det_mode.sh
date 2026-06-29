#!/bin/bash

_MODE_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_MODE_CONFIG_DIR="$(cd "$_MODE_SCRIPT_DIR/../../config" && pwd)"

source "$_MODE_CONFIG_DIR/config.conf"

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
