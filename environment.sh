#!/bin/bash

echo -e "\033[1;34m🚀 Tworzenie środowiska dla aplikacji Flask/Django\033[0m"

# 1. Parametry wejściowe
PROJECT_NAME=$1
FRAMEWORK=$2
PORT=$3

# 2. Sprawdzanie parametrów
if [ -z "$PROJECT_NAME" ] || [ -z "$FRAMEWORK" ] || [ -z "$PORT" ]; then
  echo -e "\033[1;31m❌ Użycie: ./setup_environment.sh <nazwa_projektu> <framework (django|flask)> <port>\033[0m"
  exit 1
fi

# 3. Tworzenie pliku konfiguracji Gunicorn
echo -e "\033[1;33m✍️ Tworzenie konfiguracji Gunicorn dla projektu $PROJECT_NAME...\033[0m"
GUNICORN_CONF="/etc/systemd/system/${PROJECT_NAME}_gunicorn.service"

cat <<EOF > $GUNICORN_CONF
[Unit]
Description=Gunicorn for $PROJECT_NAME
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/$PROJECT_NAME/app
ExecStart=/usr/bin/gunicorn --workers 3 --bind 0.0.0.0:$PORT ${PROJECT_NAME}.wsgi:application

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ${PROJECT_NAME}_gunicorn
systemctl start ${PROJECT_NAME}_gunicorn
echo -e "\033[1;32m✅ Gunicorn skonfigurowany i uruchomiony na porcie $PORT.\033[0m"

# 4. Tworzenie konfiguracji NGINX
echo -e "\033[1;33m✍️ Tworzenie konfiguracji NGINX dla projektu $PROJECT_NAME...\033[0m"
NGINX_CONF="/etc/nginx/sites-available/$PROJECT_NAME.conf"

cat <<EOF > $NGINX_CONF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /static/ {
        alias /var/www/$PROJECT_NAME/static/;
    }

    location /media/ {
        alias /var/www/$PROJECT_NAME/media/;
    }

    error_log /var/log/nginx/${PROJECT_NAME}_error.log;
    access_log /var/log/nginx/${PROJECT_NAME}_access.log;
}
EOF

ln -s $NGINX_CONF /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
echo -e "\033[1;32m✅ NGINX skonfigurowany dla projektu $PROJECT_NAME.\033[0m"

# 5. Backup konfiguracji NGINX
echo -e "\033[1;33m🛠️ Tworzenie backupu konfiguracji NGINX...\033[0m"
BACKUP_DIR="/var/backups/nginx"
mkdir -p $BACKUP_DIR
cp /etc/nginx/sites-available/* $BACKUP_DIR/
echo -e "\033[1;32m✅ Backup konfiguracji NGINX zapisany w $BACKUP_DIR.\033[0m"
