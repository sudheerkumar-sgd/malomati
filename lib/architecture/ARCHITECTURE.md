# Architecture

## Layers

| Layer        | Path (examples)                         | May import                          |
|-------------|------------------------------------------|-------------------------------------|
| Presentation | `lib/presentation/`, `lib/features/*/presentation/` | `domain`, `core` — **not** `data` |
| Domain      | `lib/domain/`, `lib/features/*/domain/`   | `core` only — **not** `data` / Flutter UI |
| Data        | `lib/data/`                              | `domain`, `core` — **not** `presentation` |

## Feature-first

Pilot: **`lib/features/home/`** — home use case + bloc + session side-effects. Other features can follow the same layout (`domain/`, `presentation/`, optional `data/`).

## State

- Prefer **`flutter_bloc` / `Cubit`** for feature state.
- **Ephemeral UI** (animations, controllers) stays in widgets.
- **Cross-screen globals** (e.g. approval counts) are centralized in small helpers such as `HomeSessionSideEffects` until replaced by dedicated session state.

## Dependency injection

- `lib/injection_container.dart` — app `GetIt` instance and `init()`.
- `lib/core/di/register_repositories.dart` — `ApisRepository` + feature repository interfaces.
- `lib/core/di/register_use_cases.dart` — use cases.
- `lib/core/di/register_blocs.dart` — blocs.

## Verification

Run:

`dart run tool/verify_architecture.dart`
