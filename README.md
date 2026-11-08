# Optica

[![CI](https://github.com/MFaresSlimani/optica_beta/actions/workflows/ci.yml/badge.svg)](https://github.com/MFaresSlimani/optica_beta/actions/workflows/ci.yml)

A Flutter app that connects optical stores so they can send each other lens and frame requests, track what was fulfilled, and print tickets on thermal printers.

> Status: active development. Android and iOS builds run against a Supabase backend.

## Features

- Email auth with store-owner profiles and store creation (images, location, description)
- Send and receive glasses requests between stores, with per-item tracking (done / left over) and completion messages
- Request inbox and outbox with request details
- Thermal ticket printing over USB with a preview screen
- Live in-app alerts for new and completed requests via Supabase Realtime
- Multilingual UI (GetX translations) with a language switcher
- Local draft storage for glasses items with Hive

## Tech stack

| Layer | Choice |
|---|---|
| UI / state | Flutter, GetX |
| Backend | Supabase (Postgres, Auth, Storage) with Row Level Security |
| Local storage | Hive |
| Printing | flutter_thermal_printer |

## Architecture

A 3-layer GetX structure: `core` (constants, network, routes, utils), `data` (models, providers), `presentation` (modules). Rules followed in this codebase: no business logic in views, every UI string goes through translations, named routes only. See [AGENTS.md](AGENTS.md) for the full conventions used with AI coding agents.

```
lib/
  core/          constants, network (Supabase client), routes, utils
  data/          models and providers (auth, users, stores, requests, storage)
  presentation/  feature modules (views + controllers + bindings), auth migrated
  screens/       remaining feature screens, being migrated into presentation/
  translation/   GetX translation maps
```

The database schema and RLS policies live in [supabase_schema.sql](supabase_schema.sql).

## Getting started

```bash
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://<your-project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

To use your own backend, create a Supabase project and run `supabase_schema.sql` in the SQL editor.

## Tests

```bash
flutter test
```

## License

MIT, see [LICENSE](LICENSE).
