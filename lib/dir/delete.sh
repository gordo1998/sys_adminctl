#!/bin/bash

delete_dir(){
    local dir="$1"

    echo "Eliminado ruta $dir..."
    rm -r "$dir"
    echo "Ruta eliminada exitosamente"

}