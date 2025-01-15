#!/bin/bash

echo -e "\033[1;34m🔒 Zarządzanie domenami i SSL\033[0m"

# 1. Parametry wejściowe
PROJECT_NAME=$1
DOMAIN_NAME=$2
GENERATE_SSL=${3:-no}  # Domyślnie nie generuje certyfikatu SSL

# 2. Sprawdzanie parametrów
if [ -z "$PROJECT_NAME" ] || [ -z "$DOMAIN_NAME" ]; then
  echo -e "\033[1;31m❌ Użycie: ./manage_domains.sh <nazwa_projektu> <domena> [ssl (yes/no)]\033[0m"
  exit 1
fi

# 3. Aktualizacja konfiguracji NGINX
NGINX_CONF="/etc/nginx/sites-available/$PROJECT_NAME.conf"

echo -e "\033[1;33m✍️ Aktualizowanie konfiguracji NGINX dla domeny $DOMAIN_NAME...\033[0m"
sed -i "s/server_name _;/server_name $DOMAIN_NAME www.$DOMAIN_NAME;/" $NGINX_CONF

nginx -t && systemctl reload nginx
echo -e "\033[1;32m✅ Domena $DOMAIN_NAME przypisana do projektu $PROJECT_NAME.\033[0m"

# 4. Generowanie certyfikatu SSL (opcjonalnie)
if [ "$GENERATE_SSL" == "yes" ]; then
  echo -e "\033[1;33m🔒 Generowanie certyfikatu SSL dla $DOMAIN_NAME...\033[0m"
  certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME
  if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✅ Certyfikat SSL został wygenerowany dla $DOMAIN_NAME.\033[0m"
  else
    echo -e "\033[1;31m❌ Wystąpił problem z generowaniem certyfikatu SSL.\033[0m"
  fi
else
  echo -e "\033[1;33m🌐 SSL nie został wygenerowany. Domena działa tylko na HTTP.\033[0m"
fi
