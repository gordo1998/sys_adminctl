#!/bin/bash

#Funcion que tenga un archivo y dependiendo de la extensión deribea un f
#VARIABLE

DIR_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$DIR_SOURCE/../.." && pwd)"



lpd_det_ext(){
	local entity="$1"
	local command="$2"
	local file="$3"
	case "$file" in
		*.csv)
			importOrdimport_csv "$entity" "$command" "$file"
			;;
		*.json)
			importOrdimport_json "$entity" "$command" "$file"
			;;
		*)
			echo "[ERROR 500] configuración inválida: extensión de archivo no soportada" >&2
			return 500
			;;
	esac
}

importOrdimport_csv(){
	local entity="$1"
	local command="$2"
	local file="$3"
	case "$entity" in
		user)
			source "$LIB_DIR/parser/parser_extensions/csv/user.sh"

			case "$command" in
				import)
					csv_user_parser "$file"
					;;
				dimport)
					csv_user_delete_parser "$file"
					;;
			esac
			;;
		group)
			source "$LIB_DIR/parser/parser_extensions/csv/group.sh"

			case "$command" in
				import)
					csv_group_parser "$file"
					;;
				dimport)
					csv_group_delete_parser "$file"
					;;
			esac
			;;
		dir)
			source "$LIB_DIR/parser/parser_extensions/csv/dir.sh"

			case "$command" in
				import)
					csv_dir_parser "$file"
					;;
				dimport)
					csv_dir_delete_parser "$file"
					;;
			esac
			;;
		permission-acl)
			source "$LIB_DIR/parser/parser_extensions/csv/permission.sh"
			case "$command" in
				import)
					csv_permission_acl_parser "$file"
					;;
				dimport)
					csv_permission_acl_delete_parser "$file"
					;;
			esac
			;;
		permission-basic)
			source "$LIB_DIR/parser/parser_extensions/csv/permission.sh"
			case "$command" in
				import)
					csv_permission_basic_parser "$file"
					;;
				dimport)
					csv_permission_basic_delete_parser "$file"
					;;
			esac
			;;
		permission-owner)
			source "$LIB_DIR/parser/parser_extensions/csv/permission.sh"
			case "$command" in
				import)
					csv_permission_owner_parser "$file"
					;;
			esac
			;;
		permission-group)
			source "$LIB_DIR/parser/parser_extensions/csv/permission.sh"
			case "$command" in
				import)
					csv_permission_group_parser "$file"
					;;
			esac
			;;
		service)
			source "$LIB_DIR/parser/parser_extensions/csv/service.sh"

			case "$command" in
				import)
					csv_service_parser "$file"
					;;
				dimport)
					csv_service_delete_parser "$file"
					;;
			esac
			;;
	esac
}

importOrdimport_json(){
	local entity="$1"
	local command="$2"
	local file="$3"
	case "$entity" in
		user)
			source "$LIB_DIR/parser/parser_extensions/json/user.sh"

			case "$command" in
				import)
					json_user_parser "$file"
					;;
				dimport)
					json_user_delete_parser "$file"
					;;
			esac
			;;
		group)
			source "$LIB_DIR/parser/parser_extensions/json/group.sh"

			case "$command" in
				import)
					json_group_parser "$file"
					;;
				dimport)
					json_group_delete_parser "$file"
					;;
			esac
			;;
		dir)
			source "$LIB_DIR/parser/parser_extensions/json/dir.sh"

			case "$command" in
				import)
					json_dir_parser "$file"
					;;
				dimport)
					json_dir_delete_parser "$file"
					;;
			esac
			;;
		permission-acl)
			source "$LIB_DIR/parser/parser_extensions/json/permission.sh"
			case "$command" in
				import)
					json_permission_acl_parser "$file"
					;;
				dimport)
					json_permission_acl_delete_parser "$file"
					;;
			esac
			;;
		permission-basic)
			source "$LIB_DIR/parser/parser_extensions/json/permission.sh"
			case "$command" in
				import)
					json_permission_basic_parser "$file"
					;;
				dimport)
					json_permission_basic_delete_parser "$file"
					;;
			esac
			;;
		permission-owner)
			source "$LIB_DIR/parser/parser_extensions/json/permission.sh"
			case "$command" in
				import)
					json_permission_owner_parser "$file"
					;;
			esac
			;;
		permission-group)
			source "$LIB_DIR/parser/parser_extensions/json/permission.sh"
			case "$command" in
				import)
					json_permission_group_parser "$file"
					;;
			esac
			;;
		service)
			source "$LIB_DIR/parser/parser_extensions/json/service.sh"

			case "$command" in
				import)
					json_service_parser "$file"
					;;
				dimport)
					json_service_delete_parser "$file"
					;;
			esac
			;;
	esac
}
