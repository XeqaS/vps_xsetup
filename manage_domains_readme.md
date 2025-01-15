# Skrypt `manage_domains.sh`

Skrypt `manage_domains.sh` to wszechstronne narzędzie służące do zarządzania domenami oraz certyfikatami SSL na serwerach opartych na NGINX. Automatyzuje proces konfiguracji domen oraz opcjonalne generowanie certyfikatów SSL, co znacząco upraszcza zarządzanie stronami internetowymi.

---

## Kluczowe funkcjonalności

### Zarządzanie domenami:
- Przypisanie domeny do konkretnego projektu poprzez aktualizację konfiguracji NGINX.
- Obsługa konfiguracji aliasów dla domen, takich jak `www.domena.pl`.

### Obsługa certyfikatów SSL (opcjonalna):
- Automatyczne generowanie certyfikatów SSL za pomocą `certbot`.
- Integracja certyfikatów bezpośrednio z konfiguracją NGINX, zapewniająca bezpieczeństwo ruchu HTTPS.

### Walidacja wejścia:
- Sprawdzenie poprawności podanych parametrów (nazwa projektu, domena, opcjonalnie generowanie SSL).
- Wyświetlanie czytelnych komunikatów o błędach w przypadku nieprawidłowych danych wejściowych.

### Testy konfiguracji NGINX:
- Automatyczne sprawdzanie poprawności wprowadzonej konfiguracji za pomocą `nginx -t`.
- Natychmiastowe przeładowanie NGINX w przypadku prawidłowej konfiguracji.

---

## Sposób użycia

```bash
./manage_domains.sh <nazwa_projektu> <domena> [ssl (yes/no)]
