#!/bin/bash

set -e

INSTALL_DIR="/opt/adminctl"
SERVICE_FILE="/etc/systemd/system/adminctl-api.service"
APACHE_CONF="/etc/apache2/sites-available/adminctl.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info()  { echo "[INFO]  $1"; }
log_ok()    { echo "[OK]    $1"; }
log_error() { echo "[ERROR] $1" >&2; exit 1; }

check_root(){
    [[ "$EUID" -ne 0 ]] && log_error "Ejecuta el instalador como root: sudo bash install.sh"
}

install_dependencies(){
    log_info "Instalando dependencias del sistema..."
    apt update -qq
    apt install -y apache2 libapache2-mod-proxy-html python3-venv python3-pip gunicorn jq &>/dev/null
    a2enmod proxy proxy_http &>/dev/null
    log_ok "Dependencias instaladas."
}

copy_project(){
    log_info "Copiando proyecto a $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
    cp -r "$SCRIPT_DIR" "$INSTALL_DIR"
    chmod +x "$INSTALL_DIR/bin/"*.sh
    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$INSTALL_DIR/temporal/uploads"
    touch "$INSTALL_DIR/logs/session.log"
    log_ok "Proyecto copiado."
}

setup_python(){
    log_info "Configurando entorno Python..."
    cd "$INSTALL_DIR/api"
    python3 -m venv venv
    venv/bin/pip install -q -r requirements.txt
    log_ok "Entorno Python configurado."
}

setup_service(){
    log_info "Configurando servicio Flask..."
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=adminctl Flask API
After=network.target

[Service]
User=www-data
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/api/venv/bin/gunicorn -w 4 -b 127.0.0.1:5000 "api.app:create_app()"
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable adminctl-api &>/dev/null
    systemctl restart adminctl-api
    log_ok "Servicio Flask activo."
}

setup_apache(){
    log_info "Configurando Apache..."
    cat > "$APACHE_CONF" <<EOF
<VirtualHost *:80>
    DocumentRoot $INSTALL_DIR/web

    <Directory $INSTALL_DIR/web>
        Options -Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ProxyPreserveHost On
    ProxyPass /api/ http://127.0.0.1:5000/api/
    ProxyPassReverse /api/ http://127.0.0.1:5000/api/

    ErrorLog \${APACHE_LOG_DIR}/adminctl_error.log
    CustomLog \${APACHE_LOG_DIR}/adminctl_access.log combined
</VirtualHost>
EOF
    a2ensite adminctl.conf &>/dev/null
    a2dissite 000-default.conf &>/dev/null
    systemctl reload apache2
    log_ok "Apache configurado."
}

fix_permissions(){
    log_info "Ajustando permisos..."
    chown -R www-data:www-data "$INSTALL_DIR/logs"
    chown -R www-data:www-data "$INSTALL_DIR/temporal"
    log_ok "Permisos ajustados."
}

verify(){
    log_info "Verificando instalación..."
    sleep 2
    local response
    response=$(curl -s http://localhost/api/status || true)
    if echo "$response" | grep -q '"success": true'; then
        log_ok "API respondiendo correctamente."
    else
        log_error "La API no responde. Revisa: sudo journalctl -u adminctl-api -n 20"
    fi
}

print_done(){
    local ip
    ip=$(hostname -I | awk '{print $1}')
    echo ""
    echo "========================================"
    echo "  adminctl instalado correctamente"
    echo "  Accede desde tu navegador:"
    echo "  http://$ip"
    echo "========================================"
    echo ""
}

check_root
install_dependencies
copy_project
setup_python
setup_service
setup_apache
fix_permissions
verify
print_done
