#!/bin/bash

echo -e "\033[1;34m🚀 Automatyczna instalacja PostgreSQL z obsługą wyjątków\033[0m"

# 1. Wstępna weryfikacja lokalizacji i konfiguracji
echo -e "\033[1;33m🔍 Weryfikacja istniejącej instalacji...\033[0m"

# Domyślna lokalizacja danych
DEFAULT_DATA_PATH="/var/www/postgres/postgres_data"
EXISTING_CONTAINER=$(docker ps -aq --filter "name=postgres_db")
PORT_5432=$(lsof -i:5432 | grep LISTEN)

# 2. Sprawdzanie kontenera PostgreSQL
if [ -n "$EXISTING_CONTAINER" ]; then
  echo -e "\033[1;33m⚠️ Znaleziono istniejący kontener PostgreSQL: $EXISTING_CONTAINER\033[0m"
  echo "Czy chcesz zatrzymać i usunąć istniejący kontener? (tak/nie)"
  read REMOVE_CONTAINER

  if [ "$REMOVE_CONTAINER" == "tak" ]; then
    echo -e "\033[1;31m🛑 Zatrzymywanie i usuwanie kontenera...\033[0m"
    docker stop $EXISTING_CONTAINER
    docker rm $EXISTING_CONTAINER
  else
    echo -e "\033[1;31m❌ Nie można kontynuować z istniejącym kontenerem PostgreSQL.\033[0m"
    exit 1
  fi
fi

# 3. Sprawdzanie zajętego portu 5432
if [ -n "$PORT_5432" ]; then
  echo -e "\033[1;33m⚠️ Port 5432 jest zajęty przez inną aplikację:\033[0m"
  echo "$PORT_5432"
  echo "Czy chcesz zmienić port na inny (np. 5433)? (tak/nie)"
  read CHANGE_PORT

  if [ "$CHANGE_PORT" == "tak" ]; then
    echo "Podaj nowy port:"
    read NEW_PORT
    POSTGRES_PORT=$NEW_PORT
  else
    echo -e "\033[1;31m❌ Port 5432 jest zajęty. Przerwano instalację.\033[0m"
    exit 1
  fi
else
  POSTGRES_PORT=5432
fi

# 4. Sprawdzanie lokalizacji danych
if [ -d "$DEFAULT_DATA_PATH" ]; then
  echo -e "\033[1;32m✅ Znaleziono lokalizację danych: $DEFAULT_DATA_PATH\033[0m"
else
  echo -e "\033[1;33m📂 Tworzenie nowej lokalizacji danych w $DEFAULT_DATA_PATH...\033[0m"
  sudo mkdir -p $DEFAULT_DATA_PATH
  sudo chown $USER:$USER $DEFAULT_DATA_PATH
fi

# 5. Tworzenie pliku docker-compose.yml
echo -e "\033[1;33m✍️ Tworzenie pliku docker-compose.yml...\033[0m"
cat <<EOF > /var/www/postgres/docker-compose.yml
version: '3.8'
services:
  postgres:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
      POSTGRES_DB: \${POSTGRES_DB}
    volumes:
      - ${DEFAULT_DATA_PATH}:/var/lib/postgresql/data
    ports:
      - "${POSTGRES_PORT}:5432"

volumes:
  postgres_data:
EOF

# 6. Tworzenie pliku .env
echo -e "\033[1;33m📄 Tworzenie pliku .env...\033[0m"
if [ ! -f /var/www/postgres/.env ]; then
  cat <<EOF > /var/www/postgres/.env
POSTGRES_USER=default_user
POSTGRES_PASSWORD=default_password
POSTGRES_DB=default_db
EOF
  echo -e "\033[1;32m✅ Plik .env utworzony.\033[0m"
else
  echo -e "\033[1;33m⚠️ Plik .env już istnieje. Pomijam tworzenie.\033[0m"
fi

# 7. Uruchamianie PostgreSQL w Dockerze
echo -e "\033[1;33m🚢 Uruchamianie PostgreSQL w Dockerze...\033[0m"
cd /var/www/postgres
docker-compose down
docker-compose up -d

# 8. Weryfikacja działania
echo -e "\033[1;33m🛠️ Sprawdzam status PostgreSQL...\033[0m"
if docker ps | grep postgres_db; then
  echo -e "\033[1;32m✅ PostgreSQL działa poprawnie na porcie $POSTGRES_PORT!\033[0m"
else
  echo -e "\033[1;31m❌ Kontener PostgreSQL nie działa. Sprawdź logi: docker logs postgres_db\033[0m"
  exit 1
fi

echo -e "\033[1;32m✅ Instalacja PostgreSQL zakończona sukcesem!\033[0m"
