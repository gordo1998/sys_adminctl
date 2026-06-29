#!/bin/bash

service_install(){
    local service="$1"

    echo "Instalando $service..."
    if apt install -y "$service" &>/dev/null; then
        echo "$service instalado correctamente."
    else
        echo "Error: no se ha podido instalar $service." >&2
        return 1
    fi
}

service_remove(){
    local service="$1"

    echo "Desinstalando $service..."
    if apt remove -y "$service" &>/dev/null; then
        echo "$service desinstalado correctamente."
    else
        echo "Error: no se ha podido desinstalar $service." >&2
        return 1
    fi
}

service_start(){
    local service="$1"

    systemctl start "$service" &>/dev/null || { echo "Error: no se ha podido iniciar $service." >&2; return 1; }
    echo "$service iniciado."
}

service_stop(){
    local service="$1"

    systemctl stop "$service" &>/dev/null || { echo "Error: no se ha podido parar $service." >&2; return 1; }
    echo "$service parado."
}

service_enable(){
    local service="$1"

    systemctl enable "$service" &>/dev/null || { echo "Error: no se ha podido habilitar $service." >&2; return 1; }
    echo "$service habilitado."
}

service_disable(){
    local service="$1"

    systemctl disable "$service" &>/dev/null || { echo "Error: no se ha podido deshabilitar $service." >&2; return 1; }
    echo "$service deshabilitado."
}

service_status(){
    local service="$1"

    systemctl status "$service"
}
