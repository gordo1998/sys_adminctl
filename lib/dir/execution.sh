#!/bin/bash

execution_dir(){
    local dir="$1"
    echo "Creando directorio $dir..."
    mkdir -p "$dir"
}