#!/bin/bash

_RB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_RB_LIB="$(cd "$_RB_DIR/.." && pwd)"
LOG_FILE="$(cd "$_RB_DIR/../../logs" && pwd)/session.log"

source "$_RB_LIB/mode/lib_mode_det_mode.sh"
source "$_RB_LIB/user/delete.sh"
source "$_RB_LIB/dir/delete.sh"
source "$_RB_LIB/group/delete.sh"
source "$LIB_DIR/service/execution.sh"

rb_rollback(){
    [[ ! -f "$LOG_FILE" || ! -s "$LOG_FILE" ]] && echo "No hay nada que revertir." && return 0

    echo "Iniciando rollback..."

    local root_dir
    root_dir=$(lm_det_mode)

    while IFS="|" read -r tipo accion arg1 arg2; do
        case "$tipo" in
            user)
                echo "Eliminando usuario $arg1..."
                userdel -r "$arg1" &>/dev/null && echo "Usuario $arg1 eliminado." || echo "Error al eliminar usuario $arg1." >&2
                ;;
            dir)
                echo "Eliminando directorio $arg1..."
                rm -rf "$root_dir/$arg1" && echo "Directorio $arg1 eliminado." || echo "Error al eliminar directorio $arg1." >&2
                ;;
            group)
                echo "Eliminando grupo $arg1..."
                groupdel "$arg1" &>/dev/null && echo "Grupo $arg1 eliminado." || echo "Error al eliminar grupo $arg1." >&2
                ;;
            service)
                echo "Desinstalando servicio $arg1..."
                systemctl stop "$arg1" &>/dev/null
                systemctl disable "$arg1" &>/dev/null
                apt remove -y "$arg1" &>/dev/null && echo "Servicio $arg1 desinstalado." || echo "Error al desinstalar $arg1." >&2
                ;;
            permission)
                local complete_dir="$root_dir/$arg1"
                case "$accion" in
                    acl)
                        local entrada
                        IFS=':' read -r tipo_acl nombre _ <<< "$arg2"
                        entrada="$tipo_acl:$nombre"
                        setfacl -x "$entrada" "$complete_dir" &>/dev/null && echo "ACL $entrada eliminada de $arg1." || echo "Error al eliminar ACL de $arg1." >&2
                        ;;
                    basic|owner|group)
                        echo "Permiso $accion en $arg1 registrado — reversión manual necesaria."
                        ;;
                esac
                ;;
        esac
    done <<< "$(tac "$LOG_FILE")"

    rm -f "$LOG_FILE"
    echo "Rollback completado. Log eliminado."
}
