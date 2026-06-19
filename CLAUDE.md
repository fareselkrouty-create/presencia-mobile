# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Presencia Mobile is a Flutter employee attendance tracking app (pointage). UI text is in French. The app uses GetX for state management, routing, and dependency injection.

**Note:** `lib/main.dart` still contains the default Flutter counter template — it needs to be wired up to use `GetMaterialApp` with `AppPages`, `AppBindings`, and `AppTheme` from `lib/configs/`.

## Build & Development Commands

```bash
flutter pub get              # Install dependencies
flutter run                  # Run in debug mode
flutter run -d <device_id>   # Run on specific device
flutter build apk --release  # Build Android APK
flutter build ios --release  # Build iOS
flutter test                 # Run all tests
flutter analyze              # Static analysis (uses flutter_lints)
dart format lib/             # Format code
```

## Architecture

**Pattern:** GetX-based layered architecture with controllers, services, models, and reactive UI.

### Layer Responsibilities

- **`configs/`** — Routes (`app_routes.dart`), theme, API endpoints (`api_config.dart`), global DI bindings (`app_bindings.dart`)
- **`controllers/`** — `GetxController` subclasses: `AuthController`, `PointageController`, `HistoriqueController`, `ProfileController`. Business logic lives here.
- **`services/`** — `GetxService` subclasses registered as permanent singletons in `AppBindings`: `StorageService` (GetStorage), `ApiService` (Dio + JWT interceptor), `AuthService`
- **`models/`** — Data classes with `fromJson`/`toJson`: `UserModel`, `PointageModel`, `HistoriqueModel`, `AuthResponseModel`
- **`ui/`** — `StatelessWidget` screens using `Obx()` for reactive rebuilds. `MainScreen` hosts bottom navigation with Home, Checkin, Historique, Profile tabs.
- **`components/`** — Reusable widgets: `CustomButton` (typed: primary/secondary/danger/outline), `CustomInput`, `AppSnackbar`, `StatusBadge`, `PointageCard`, `LoadingOverlay`
- **`utils/`** — Constants, validators, DateTime/String extensions, date formatting helpers

### Dependency Injection Flow

1. `AppBindings` registers global services (`StorageService`, `ApiService`, `AuthService`) as permanent singletons via `Get.put()`
2. Each `GetPage` in `app_routes.dart` lazily binds its controllers via `Get.lazyPut()`
3. The `/home` route binds `PointageController`, `HistoriqueController`, and `ProfileController` together

### API & Auth

- Base URL hardcoded in `api_config.dart` (`http://192.168.1.1:8080/api`)
- JWT Bearer token stored in GetStorage, injected by `ApiService` interceptor
- 401 responses trigger automatic token refresh; failure redirects to login
- Endpoints: `/auth/login`, `/pointage/check-in`, `/pointage/check-out`, `/pointage/historique`, `/employe/profil`

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management, routing, DI |
| `dio` | HTTP client with interceptors |
| `get_storage` | Local key-value persistence |
| `flutter_secure_storage` | Encrypted token storage |
| `geolocator` + `permission_handler` | GPS location for check-in/check-out |
| `intl` | Date/time formatting |
| `connectivity_plus` | Network status detection |

## Conventions

- **Files:** snake_case (`auth_controller.dart`)
- **Classes:** PascalCase (`PointageController`)
- **State:** `Rxn<T>` for nullable observables, `Obx()` for reactive UI, `ever()`/`debounce()` for reactive listeners
- **Error feedback:** `AppSnackbar` with types (success, error, warning, info)
- **Attendance statuses:** PRESENT, ABSENT, RETARD, EN_CONGE (defined in `utils/constants.dart`)
- **Date formats:** `yyyy-MM-dd` for dates, `HH:mm` for times (see `utils/constants.dart`)
