# Dokumentacja skryptu `setup_environment.sh`

## Opis

Skrypt `setup_environment.sh` automatyzuje proces konfiguracji środowiska serwerowego dla aplikacji webowych opartych na Flask lub Django. Tworzy i konfiguruje Gunicorn oraz NGINX, co umożliwia uruchomienie aplikacji w wydajny i skalowalny sposób. Dodatkowo skrypt generuje backup konfiguracji NGINX, zapewniając bezpieczeństwo danych.

---

## Funkcjonalności

### 1. Tworzenie konfiguracji Gunicorn
- Generuje plik usługi systemd dla Gunicorn, umożliwiając zarządzanie procesami aplikacji.
- Automatycznie uruchamia usługę Gunicorn na wskazanym porcie.

### 2. Konfiguracja serwera NGINX
- Tworzy plik konfiguracji NGINX z odpowiednimi ustawieniami dla przekierowania ruchu do Gunicorn.
- Obsługuje pliki statyczne i multimedialne (`static/media`).
- Automatycznie włącza konfigurację NGINX i przeładowuje usługę.

### 3. Tworzenie backupu konfiguracji NGINX
- Kopiuje wszystkie pliki konfiguracji z katalogu `/etc/nginx/sites-available/` do folderu backupu.
- Domyślny katalog backupu: `/var/backups/nginx`.

### 4. Walidacja parametrów wejściowych
- Skrypt sprawdza poprawność i kompletność parametrów wejściowych.
- W przypadku błędów wyświetla czytelny komunikat.

---

## Sposób użycia

Skrypt uruchamia się z trzema parametrami:
```bash
./setup_environment.sh <nazwa_projektu> <framework (django|flask)> <port>
