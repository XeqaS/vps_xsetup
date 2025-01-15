# vps_xsetup
Skrypty do automatyzacji konfiguracji VPS

# Skrypty automatyzujące konfigurację serwera i aplikacji

## Opis repozytorium

Repozytorium zawiera zestaw trzech skryptów Bash, które automatyzują kluczowe procesy konfiguracyjne dla środowisk serwerowych i aplikacyjnych. Każdy skrypt jest zoptymalizowany do realizacji konkretnego zadania, co upraszcza zarządzanie serwerami i minimalizuje ryzyko błędów manualnych.

---

## Zawartość repozytorium

### 1. Skrypt: `install_postgresql.sh`

#### Cel
Automatyzuje instalację i konfigurację PostgreSQL przy użyciu Dockera.

#### Kluczowe funkcjonalności:
- Weryfikacja istniejącej instalacji PostgreSQL (kontener Docker).
- Zarządzanie konfliktami portów.
- Tworzenie plików konfiguracyjnych `docker-compose.yml` i `.env`.
- Automatyczne uruchamianie PostgreSQL w Dockerze.
- Obsługa wyjątków i informowanie użytkownika o stanie instalacji.

#### Użycie:
```bash
./install_postgresql.sh
```

---

### 2. Skrypt: `setup_environment.sh`

#### Cel
Tworzy środowiska dla aplikacji webowych opartych na frameworkach Flask lub Django.

#### Kluczowe funkcjonalności:
- Tworzenie i konfigurowanie Gunicorn dla wskazanej aplikacji.
- Generowanie konfiguracji NGINX z obsługą plików statycznych i multimedialnych.
- Obsługa dynamicznie określonych portów aplikacji.
- Tworzenie kopii zapasowych konfiguracji NGINX.

#### Użycie:
```bash
./setup_environment.sh <nazwa_projektu> <framework (django|flask)> <port>
```

#### Przykład:
```bash
./setup_environment.sh moj_projekt django 8000
```

---

### 3. Skrypt: `manage_domains.sh`

#### Cel
Zarządza domenami i certyfikatami SSL dla serwerów opartych na NGINX.

#### Kluczowe funkcjonalności:
- Przypisywanie domen do wskazanych projektów.
- Automatyczne generowanie certyfikatów SSL przy użyciu Let's Encrypt (`certbot`).
- Sprawdzanie poprawności konfiguracji NGINX i jej przeładowanie.

#### Użycie:
```bash
./manage_domains.sh <nazwa_projektu> <domena> [ssl (yes/no)]
```

#### Przykład:
```bash
./manage_domains.sh moj_projekt example.com yes
```

---

## Wymagania systemowe

- Zainstalowany Docker i Docker Compose (dla PostgreSQL).
- Serwer NGINX z uprawnieniami administratora.
- Zainstalowany `certbot` (dla zarządzania certyfikatami SSL).
- System Linux lub inny kompatybilny z Bash.

---

## Zalety repozytorium

- **Automatyzacja:** Eliminacja manualnych kroków w konfiguracji serwerów i aplikacji.
- **Elastyczność:** Skrypty dostosowane do różnych potrzeb, od baz danych po zarządzanie domenami.
- **Skalowalność:** Łatwe uruchamianie środowisk produkcyjnych i testowych.
- **Bezpieczeństwo:** Obsługa wyjątków i tworzenie kopii zapasowych konfiguracji.

---

## Sugerowane użycie

1. **Skonfiguruj bazę danych PostgreSQL:**
   Uruchom `install_postgresql.sh`, aby przygotować środowisko bazy danych.

2. **Utwórz środowisko aplikacyjne:**
   Skorzystaj z `setup_environment.sh`, aby skonfigurować backend aplikacji w Django lub Flask.

3. **Zarządzaj domenami i certyfikatami SSL:**
   Użyj `manage_domains.sh`, aby przypisać domeny i zabezpieczyć ruch HTTPS.

---

**Licencja:** Repozytorium udostępniane na zasadach licencji MIT. Możesz korzystać, modyfikować i rozwijać te skrypty zgodnie z własnymi potrzebami. 🚀

