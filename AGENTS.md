# AGENTS.md — Optica Flutter Project

## Architecture (NOT full clean architecture — 3-layer GetX structure)
lib/

├── core/

│   ├── constants/        # ALL strings, colors, asset paths, API keys/URLs, table names, pref keys — nothing hardcoded outside this

│   ├── translations/      # GetX translation files (en_US, fr_FR, ar_DZ...) — every UI-facing string uses .tr

│   ├── theme/

│   ├── network/           # supabase_client.dart, dio client/interceptors if used

│   ├── utils/

│   └── routes/

│       ├── app_routes.dart   # route name constants only

│       └── app_pages.dart    # GetPage list, each route tied to its binding

│

├── data/

│   ├── models/             # data shape only, no logic

│   └── providers/          # ONE FILE PER RESOURCE for CRUD/API calls (auth_provider.dart, appointments_provider.dart, etc). This is the ONLY layer that talks to Supabase/REST/WebSocket.

│

└── presentation/

├── modules/

│   └── <feature_name>/

│       ├── controllers/   # ALL logic and state lives here

│       ├── views/         # render only

│       │   └── widgets/   # widgets used ONLY by this view

│       └── bindings/      # GetX binding, lazyPut controllers per route

└── widgets/             # shared widgets used across multiple views

## Hard Rules — DO NOT BREAK

1. **No logic in views or widgets.** Ever. No `onPressed` with logic inline, no async calls, no data transforms, no business logic in `build()`. Views only watch controllers (`Obx`/`GetX`) and render. If a view needs to "do" something, it calls a controller method — full stop.

2. **No hardcoded strings/values anywhere outside `core/constants/`.** This includes: UI text, route names, asset paths, API/Supabase table names, bucket names, env keys, shared_prefs keys, error messages.

3. **All UI-facing text uses `.tr`.** Every string the user sees comes from `core/translations/` via GetX i18n, even if only one language is currently supported.

4. **Flow is strict and one-directional:**
   `View → Controller method → Provider (API/CRUD call) → Model → Controller updates .obs state → View rebuilds`
   Views never call providers directly. Controllers never build UI. Providers never hold state.

5. **One provider file per resource/domain** in `data/providers/` (e.g. `auth_provider.dart`, `appointments_provider.dart`). Each handles all CRUD/API calls for that resource only.

6. **Routing is GetX named routes only.** Navigate via `Get.toNamed(Routes.X)` — never inline route strings, never `Navigator.push`. Each feature module has its own binding for lazy DI (`Get.lazyPut`), nothing eagerly loaded at app start unless required.

7. **State management is GetX reactive (`.obs` + `Obx`/`GetX` widgets)** — no setState, no other state management libraries mixed in.

8. **Models are plain data classes.** No business logic, no API calls, no GetX dependency inside models.

9. **Keep provider method signatures stable** when changing backend/implementation details (e.g. Firebase → Supabase) — controllers should never need to change just because the data source changed.

10. When unsure where something goes, default to: logic → controller, data access → provider, display → view/widget. If touching more than one of these layers for a "simple" change, stop and re-check the rule is actually being followed.

## When making changes

- Before editing, scan existing files in the relevant module/provider to match existing naming conventions and patterns exactly — don't introduce a new style.
- Don't refactor unrelated files unless explicitly asked.
- If a required architectural decision is ambiguous (e.g. where a new shared util goes), ask before assuming.