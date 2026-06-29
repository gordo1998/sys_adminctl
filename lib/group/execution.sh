#!/bin/bash

group_exec_comm(){
    local group="$1"

    echo "Creando grupo $group..."

    if sudo groupadd "$group" &>/dev/null; then
        echo "Grupo $group creado correctamente."
    else
        echo "El grupo $group no se ha podido crear."
        return 1
    fi
}
