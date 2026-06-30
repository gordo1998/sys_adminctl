#!/bin/bash

set -e

INSTALL_DIR="/opt/adminctl"
SERVICE_FILE="/etc/systemd/system/adminctl-api.service"
APACHE_CONF="/etc/apache2/sites-available/adminctl.conf"

log_info()  { echo "[INFO]  $1"; }
log_ok()    { echo "[OK]    $1"; }
log_error() { echo "[ERROR] $1" >&2; exit 1; }

check_root(){
    if [[ "$EUID" -ne 0 ]]; then
        log_error "Ejecuta el desinstalador como root: sudo bash uninstall.sh"
    fi
}

stop_service(){
    log_info "Deteniendo servicio adminctl-api..."
    systemctl stop adminctl-api &>/dev/null || true
    systemctl disable adminctl-api &>/dev/null || true
    log_ok "Servicio detenido y desactivado."
}

remove_service(){
    log_info "Eliminando servicio systemd..."
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
    log_ok "Servicio eliminado."
}

remove_apache(){
    log_info "Eliminando configuración de Apache..."
    a2dissite adminctl.conf &>/dev/null || true
    a2ensite 000-default.conf &>/dev/null || true
    rm -f "$APACHE_CONF"
    systemctl reload apache2 &>/dev/null || true
    log_ok "Configuración Apache eliminada."
}

remove_project(){
    log_info "Eliminando archivos de $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
    log_ok "Archivos eliminados."
}

check_root
stop_service
remove_service
remove_apache
remove_project

echo ""
echo "========================================"
echo "  adminctl desinstalado correctamente"
echo "========================================"
echo ""
