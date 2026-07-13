# Fitness

Flutter app focused exclusively on diet and workout management.

The client lives in [`app/`](app/). Authentication and profile management are
kept as shared user flows; finance and task features now live in their own
projects:

- `D:\Projetos\finances\app`
- `D:\Projetos\tasks\app`

## Run

```bash
cd app
flutter pub get
flutter run
```

Configure `app/.env` with `URL_API` before running the application.
