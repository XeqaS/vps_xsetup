# Dokumentacja skryptu `install_postgresql.sh`

## Opis

Skrypt `install_postgresql.sh` automatyzuje proces instalacji PostgreSQL przy użyciu Dockera. Umożliwia sprawdzenie istniejących instalacji, zarządzanie konfliktem portów oraz tworzenie plików konfiguracyjnych. Skrypt obsługuje sytuacje wyjątkowe, takie jak wykrycie istniejącego kontenera PostgreSQL lub zajęcie domyślnego portu 5432.

---

## Funkcjonalności

### 1. Weryfikacja istniejącej instalacji
- Sprawdza, czy istnieje kontener PostgreSQL na serwerze.
- Wykrywa, czy port 5432 jest już zajęty przez inną aplikację.
- Informuje użytkownika i oferuje opcje rozwiązania konfliktów (np. zmiana portu lub usunięcie istniejącego kontenera).

### 2. Tworzenie lokalizacji danych
- Domyślna lokalizacja: `/var/www/postgres/postgres_data`.
- Tworzy folder, jeśli nie istnieje, i nadaje odpowiednie uprawnienia.

### 3. Generowanie plików konfiguracyjnych
- **docker-compose.yml**:
  - Definiuje usługę PostgreSQL z obrazem `postgres:15`.
  - Ustawia porty, zmienne środowiskowe oraz lokalizację danych.
- **.env**:
  - Zawiera dane uwierzytelniające do PostgreSQL, takie jak użytkownik, hasło i nazwa bazy danych.
  - Automatycznie tworzy plik, jeśli nie istnieje.

### 4. Uruchamianie PostgreSQL
- Uruchamia kontener PostgreSQL w trybie odłączonym (`docker-compose up -d`).
- Automatycznie zatrzymuje istniejące kontenery dla uniknięcia konfliktów.

### 5. Obsługa wyjątków
- Wykrywa i obsługuje następujące problemy:
  - Istniejący kontener PostgreSQL.
  - Zajęty port 5432.
  - Brak uprawnień do tworzenia folderów danych.
- Wyświetla czytelne komunikaty dla użytkownika w kolorach:
  - Niebieski: Informacje o procesie.
  - Żółty: Ostrzeżenia i pytania do użytkownika.
  - Zielony: Sukces.
  - Czerwony: Błędy i przerwanie instalacji.

---

## Sposób użycia

```bash
./install_postgresql.sh
```

### Interaktywność:
- Skrypt wymaga odpowiedzi na pytania:
  - Czy usunąć istniejący kontener PostgreSQL?
  - Czy zmienić port, jeśli domyślny 5432 jest zajęty?
  - Podanie nowego portu, jeśli wymagane.

---

## Szczegóły techniczne

### 1. Weryfikacja istniejącego kontenera
- Komenda:
  ```bash
  docker ps -aq --filter "name=postgres_db"
  ```
- Jeśli kontener istnieje, użytkownik decyduje o jego usunięciu:
  ```bash
  docker stop <id_kontenera>
  docker rm <id_kontenera>
  ```

### 2. Sprawdzanie portu 5432
- Komenda:
  ```bash
  lsof -i:5432 | grep LISTEN
  ```
- W przypadku zajętości portu użytkownik może wybrać nowy port, np. 5433.

### 3. Generowanie plików konfiguracyjnych
- **docker-compose.yml**:
  - Lokalizacja: `/var/www/postgres/docker-compose.yml`.
  - Definicja usługi PostgreSQL z ustawieniami portów i wolumenów.
- **.env**:
  - Lokalizacja: `/var/www/postgres/.env`.
  - Zawiera domyślne dane logowania:
    ```
    POSTGRES_USER=default_user
    POSTGRES_PASSWORD=default_password
    POSTGRES_DB=default_db
    ```

### 4. Tworzenie lokalizacji danych
- Lokalizacja domyślna: `/var/www/postgres/postgres_data`.
- Tworzenie folderu:
  ```bash
  sudo mkdir -p /var/www/postgres/postgres_data
  sudo chown $USER:$USER /var/www/postgres/postgres_data
  ```

### 5. Uruchamianie PostgreSQL
- Wywołanie Dockera:
  ```bash
  docker-compose down
  docker-compose up -d
  ```
- Weryfikacja działania kontenera:
  ```bash
  docker ps | grep postgres_db
  ```

---

## Przykładowe komunikaty wyjściowe

- Znalezienie istniejącego kontenera:
  ```
  ⚠️ Znaleziono istniejący kontener PostgreSQL: 123abc456
  Czy chcesz zatrzymać i usunąć istniejący kontener? (tak/nie)
  ```

- Port 5432 zajęty:
  ```
  ⚠️ Port 5432 jest zajęty przez inną aplikację:
  postgres   12345   user   6u  IPv4  12345678  TCP *:5432 (LISTEN)
  Czy chcesz zmienić port na inny (np. 5433)? (tak/nie)
  ```

- Sukces instalacji:
  ```
  ✅ PostgreSQL działa poprawnie na porcie 5432!
  ✅ Instalacja PostgreSQL zakończona sukcesem!
  ```

---

## Zalety

- **Automatyzacja:** Skrypt obsługuje większość konfiguracji bez interwencji manualnej.
- **Elastyczność:** Możliwość dostosowania portu i zmiennych środowiskowych.
- **Bezpieczeństwo:** Tworzenie kopii zapasowej konfiguracji NGINX i obsługa wyjątków.
- **Czytelność:** Intuicyjne komunikaty ułatwiają nawigację i zrozumienie procesu.

---

**Licencja:** Skrypt dostępny na zasadach licencji MIT. Można go dowolnie modyfikować i rozwijać zgodnie z potrzebami! 🚀

