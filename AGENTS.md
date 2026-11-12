# AGENTS.md — Optica Flutter Project

## Architecture (NOT full clean architecture — 3-layer GetX structure)

```
lib/
├── main.dart / bootstrap.dart / app.dart   # entry, app-wide DI, GetMaterialApp
├── core/
│   ├── constants/     # ALL strings (translation keys), colors, spacing, assets, links,
│   │                  # Supabase table/column/bucket names, storage keys — nothing hardcoded elsewhere
│   ├── theme/         # AppTheme (Material 3 light/dark) + OpticaPalette theme extension
│   ├── translations/  # GetX maps (fr_FR, en_UK, ar_AR, kab_KAB) — every UI string uses .tr
│   ├── services/      # app-wide state as GetxService: SessionService, PreferencesService, AppInfoService
│   ├── network/       # supabase_client.dart
│   ├── routes/        # app_routes.dart (names), app_pages.dart (GetPage + binding), route_guards.dart
│   └── utils/         # PURE Dart logic, no Flutter UI, no I/O: validators, LensOrder, Ticket, DateFormats
│
├── data/
│   ├── models/        # immutable data classes (fromMap/toMap/copyWith/==), no business logic, no GetX
│   └── providers/     # ONE FILE PER RESOURCE. The ONLY layer that talks to Supabase, Hive or the
│                      # printer plugin. Providers throw DataException and nothing else.
│
└── presentation/
    ├── modules/<feature>/
    │   ├── bindings/     # Get.lazyPut controllers per route (route arguments are read here)
    │   ├── controllers/  # ALL logic and state
    │   └── views/        # render only
    │       └── widgets/  # widgets used ONLY by this feature
    ├── services/      # UI-facing app services: FeedbackService (snackbars/dialogs), RealtimeService
    └── widgets/       # shared design system used across features
```

## Hard Rules — DO NOT BREAK

1. **No logic in views or widgets.** No async calls, no data transforms, no business logic in `build()`. Views watch controllers (`Obx`/`GetView`) and render. If a view needs to "do" something, it calls a controller method — full stop.

2. **No hardcoded strings/values anywhere outside `core/constants/`.** This includes: UI text, route names, asset paths, Supabase table/column/bucket names, env keys, storage keys, links, error messages. Spacing, radii and durations come from `AppSpacing` / `AppRadius` / `AppDurations`; colors from `context.colors` / `context.palette` (never raw `Color(0x...)` in a view).

3. **All UI-facing text uses `.tr` (or `.trParams`).** Every key lives in `AppStrings` and must exist in every language — `test/core/translations_test.dart` enforces this, including `@placeholders`.

4. **Flow is strict and one-directional:**
   `View → Controller method → Provider (API/CRUD call) → Model → Controller updates .obs state → View rebuilds`
   Views never call providers directly. Controllers never build UI (they use `FeedbackService` for snackbars and confirm dialogs). Providers never hold state.

5. **One provider file per resource/domain** in `data/providers/`. Each handles all calls for that resource only and maps backend errors to `DataException`.

6. **Routing is GetX named routes only.** `Get.toNamed(AppRoutes.x, arguments: ...)` — never inline route strings, never `Navigator.push`. Each route has a binding for lazy DI. Only `bootstrap.dart` registers things eagerly (providers and app-wide services).

7. **State management is GetX reactive (`.obs` + `Obx`/`GetView`)** — no other state library. `setState` is allowed **only** for purely visual, widget-local animation state (e.g. press-scale in `AppButton`, the skeleton pulse) — never for data.

8. **Models are plain immutable data classes.** No business logic, no API calls, no GetX dependency. Pure helpers that operate on models go in `core/utils/` and get unit tests.

9. **Keep provider method signatures stable** when changing backend/implementation details — controllers should never change just because the data source changed. Providers expose plain Dart types (ids, models), never Supabase types.

10. When unsure where something goes, default to: logic → controller (or `core/utils` if pure), data access → provider, display → view/widget. If touching more than one of these layers for a "simple" change, stop and re-check the rule is actually being followed.

## Testability

- Controllers take their dependencies as optional constructor parameters, defaulting to `Get.find`. Tests pass fakes directly (`test/helpers/fakes.dart`), no mocking library needed.
- Time-dependent controllers take a `clock` parameter.
- Stored data formats are backward compatible: `LensItem.encode`/`decode` must round-trip the legacy string format byte for byte (see `test/data/lens_item_test.dart`).

## Verification before finishing a change

```bash
dart format lib test                       # page width 100 (analysis_options.yaml)
flutter analyze --fatal-infos              # must report no issues
flutter test --exclude-tags screenshots    # must pass
flutter test --tags screenshots --update-goldens   # when UI changed: refresh docs/screenshots
```

## When making changes

- Before editing, scan existing files in the relevant module/provider to match naming conventions and patterns exactly — don't introduce a new style.
- Reuse `presentation/widgets/` (AppButton, AppTextField, SurfaceCard, GroupedCard, SectionHeader, EmptyState/ErrorState, StatusBadge, BottomActionBar, ...) before writing a new widget.
- Don't refactor unrelated files unless explicitly asked.
- If a required architectural decision is ambiguous (e.g. where a new shared util goes), ask before assuming.
