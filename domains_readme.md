# Dokumentacja skryptu `manage_domains.sh`

## Opis

Skrypt `manage_domains.sh` został stworzony w celu uproszczenia zarządzania domenami oraz konfiguracją SSL na serwerach korzystających z NGINX. Automatyzuje proces przypisywania domeny do projektu oraz generowania certyfikatów SSL, co czyni go idealnym narzędziem dla administratorów serwerów i deweloperów.

---

## Funkcjonalności

### 1. Aktualizacja konfiguracji NGINX
- Przypisuje domenę do wskazanego projektu poprzez modyfikację pliku konfiguracyjnego NGINX w katalogu `sites-available`.
- Dodaje alias `www.domena` w konfiguracji.
- Sprawdza poprawność konfiguracji za pomocą `nginx -t`.
- Automatycznie przeładowuje NGINX w celu zastosowania zmian.

### 2. Obsługa certyfikatów SSL (opcjonalna)
- Wykorzystuje narzędzie `certbot` do generowania darmowych certyfikatów SSL od Let's Encrypt.
- Obsługuje zarówno domenę główną, jak i jej alias (np. `www.domena`).
- Informuje użytkownika o sukcesie lub błędzie podczas generowania certyfikatu.

### 3. Walidacja danych wejściowych
- Sprawdza, czy użytkownik podał wszystkie wymagane parametry (nazwa projektu, domena).
- Wyświetla pomocny komunikat, jeśli brakuje wymaganych danych.

---

## Sposób użycia

Skrypt uruchamia się z trzema parametrami:
```bash
./manage_domains.sh <nazwa_projektu> <domena> [ssl (yes/no)]
```

### Parametry:
1. `nazwa_projektu` (wymagane): Nazwa projektu, do którego ma zostać przypisana domena.
2. `domena` (wymagane): Pełna nazwa domeny, np. `example.com`.
3. `ssl` (opcjonalne): Decyzja o generowaniu certyfikatu SSL (`yes` lub `no`). Domyślnie ustawione na `no`.

### Przykłady:

#### Przypisanie domeny bez generowania SSL:
```bash
./manage_domains.sh moj-projekt example.com
```

#### Przypisanie domeny z generowaniem SSL:
```bash
./manage_domains.sh moj-projekt example.com yes
```

---

## Wymagania systemowe

- Serwer z zainstalowanym NGINX.
- Narzędzie `certbot` dla obsługi certyfikatów SSL.
- Uprawnienia administratora (root) do modyfikacji plików konfiguracyjnych NGINX i zarządzania usługami.

---

## Szczegóły techniczne

1. **Aktualizacja konfiguracji NGINX**:
   - Ścieżka do konfiguracji: `/etc/nginx/sites-available/<nazwa_projektu>.conf`.
   - Komenda `sed` modyfikuje linię `server_name _;`, przypisując do niej wartość `server_name <domena> www.<domena>;`.
   - Po wprowadzeniu zmian skrypt wykonuje test konfiguracji za pomocą `nginx -t`, a następnie przeładowuje usługę `systemctl reload nginx`.

2. **Generowanie certyfikatu SSL**:
   - Wywołuje `certbot --nginx` z podaniem domeny głównej oraz aliasu `www.<domena>`.
   - W przypadku niepowodzenia generowania certyfikatu wyświetlany jest komunikat błędu.

---

## Informacje dodatkowe

- Jeśli parametr `ssl` nie zostanie podany, skrypt domyślnie nie generuje certyfikatu SSL.
- Skrypt został zaprojektowany z myślą o prostocie użytkowania, co czyni go przyjaznym nawet dla początkujących administratorów.

---

## Komunikaty wyjściowe

- Kolorowe komunikaty pomagają w nawigacji i informowaniu o stanie operacji:
  - Niebieski: Informacje ogólne.
  - Żółty: Ostrzeżenia i aktualizacje.
  - Zielony: Sukces.
  - Czerwony: Błędy i problemy.

Przykładowy komunikat:
```
🔒 Zarządzanie domenami i SSL
✍️ Aktualizowanie konfiguracji NGINX dla domeny example.com...
✅ Domena example.com przypisana do projektu moj-projekt.
🌐 SSL nie został wygenerowany. Domena działa tylko na HTTP.
```

---

## Zalety skryptu

- **Automatyzacja:** Upraszcza zarządzanie domenami i SSL, redukując ryzyko błędów manualnych.
- **Elastyczność:** Obsługuje zarówno proste przypisywanie domen, jak i bardziej zaawansowane operacje z certyfikatami SSL.
- **Przejrzystość:** Intuicyjne komunikaty pozwalają użytkownikowi łatwo zrozumieć, co się dzieje na każdym etapie.

---

**Licencja:** Skrypt dostępny na zasadach licencji MIT. Używaj, modyfikuj i rozwijaj go zgodnie z własnymi potrzebami! 😊

