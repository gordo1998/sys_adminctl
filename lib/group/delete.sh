#!/bin/bash

delete_group(){
    local group="$1"

    if sudo groupdel "$group" &>/dev/null; then
        echo "Grupo $group eliminado correctamente."
    else
        echo "El grupo $group no existe o no se ha podido eliminar correctamente."
        return 1
    fi
}
