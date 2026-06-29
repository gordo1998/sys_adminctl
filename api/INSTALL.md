# Instalación en Ubuntu Server

## 1. Dependencias del sistema

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv apache2 libapache2-mod-proxy-html
sudo a2enmod proxy proxy_http
```

## 2. Entorno virtual e instalación de la API

```bash
cd /ruta/adminctl/api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 3. Arrancar la API

```bash
source venv/bin/activate
python app.py
```

Para producción, usar gunicorn:
```bash
pip install gunicorn
gunicorn -w 4 -b 127.0.0.1:5000 "api.app:create_app()"
```

## 4. Configurar Apache como proxy

```bash
sudo cp apache.conf /etc/apache2/sites-available/adminctl.conf
sudo a2ensite adminctl.conf
sudo systemctl reload apache2
```

## 5. Verificar

```bash
curl http://localhost/api/status
```

## Endpoints disponibles

| Método | Ruta            | Descripción                              |
|--------|-----------------|------------------------------------------|
| GET    | /api/status     | Estado actual del entorno                |
| POST   | /api/preview    | Previsualizar archivo sin ejecutar       |
| POST   | /api/import     | Importar entidades desde archivo         |
| POST   | /api/dimport    | Eliminar entidades desde archivo         |
| POST   | /api/reset      | Eliminar todo lo creado                  |

## Parámetros de /api/preview, /api/import y /api/dimport

- `file`: archivo CSV, JSON o XML
- `type`: tipo de entidad (`user`, `group`, `dir`, `service`, `permission-acl`, `permission-basic`, `permission-owner`, `permission-group`)

## Ejemplo de uso con curl

```bash
# Preview
curl -X POST http://localhost/api/preview \
  -F "file=@grupos.csv" \
  -F "type=group"

# Import
curl -X POST http://localhost/api/import \
  -F "file=@grupos.csv" \
  -F "type=group"

# Reset
curl -X POST http://localhost/api/reset
```
