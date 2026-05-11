# Home feature

- **Domain**: [`home_usecase.dart`](domain/home_usecase.dart) — dashboard, favorites, counts, weather, FCM token; depends on [`HomeRepository`](../../domain/repository/home_repository.dart) only.
- **Presentation**: [`presentation/bloc/`](presentation/bloc/) — `HomeBloc` / `HomeState`; [`home_session_side_effects.dart`](presentation/home_session_side_effects.dart) applies bloc emissions to `ConstantConfig` and local `ValueNotifier`s.
- **UI**: still under `lib/presentation/ui/home/` (re-export path unchanged for routes); migrate screens here incrementally if desired.
