#!/bin/bash

_PC_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../lib" && pwd)"

source "$_PC_LIB/permission/validation.sh"
source "$_PC_LIB/permission/execution.sh"
source "$_PC_LIB/mode/lib_mode_det_mode.sh"
source "$_PC_LIB/log/log.sh"


dir_perm(){
	local user dir root_dir complete_dir permiso group

    case "$1" in
        -a|--acl)
            shift 2
            dir="$1"
            permiso="$2"
			#Validar que la info sea correcta
			acl_validation "$dir" "$permiso" || return 1
			root_dir=$(lm_det_mode)
			complete_dir="$root_dir/$dir"
			#Ejecutar permisos
			acl_execution "$complete_dir" "$permiso" || return 1
			log_action "permission|acl|$dir|$permiso"
            ;;
        -b|--basic)
            shift
            dir="$1"
            permiso="$2"
			root_dir=$(lm_det_mode)
			complete_dir="$root_dir/$dir"
			basic_validation "$dir" "$permiso" || return 1
			basic_execution "$complete_dir" "$permiso" || return 1
			log_action "permission|basic|$dir|$permiso"
            ;;
        -o|--owner)
            shift
            dir="$1"
            user="$2"
			root_dir=$(lm_det_mode)
			complete_dir="$root_dir/$dir"
			owner_validation "$dir" "$user" || return 1
			owner_execution "$complete_dir" "$user" || return 1
			log_action "permission|owner|$dir|$user"
            ;;
        -g|--group)
            shift
            dir="$1"
            group="$2"
            group_validation "$dir" "$group" || return 1
            root_dir=$(lm_det_mode)
            complete_dir="$root_dir/$dir"
            group_execution "$complete_dir" "$group" || return 1
            log_action "permission|group|$dir|$group"
            ;;
        *)
            echo "Error: tipo de permiso no reconocido" >&2
            return 1
            ;;
    esac
}
