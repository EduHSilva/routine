# Repository Guidelines

## Project Structure & Module Organization
This repository contains a routine-management Flutter app and Go API.

- `app/` is the Flutter client. Dart code lives in `app/lib/`, grouped by `views/`, `view_models/`, `services/`, `models/`, `widgets/`, and `config/`.
- `app/assets/i18n/` and `app/assets/images/` contain bundled translations and images listed in `pubspec.yaml`.
- `backend/` is the Go service. `main.go` starts the API; `router/` wires routes, `handler/` contains feature handlers, `schemas/` defines data models, and `config/` holds setup code.
- `backend/docs/` contains generated Swagger files. `backend/seeds/` stores seed scripts and JSON data. Root `imgs/` stores README screenshots and demo media.

## Build, Test, and Development Commands
From `app/`:

- `flutter pub get` installs Dart dependencies.
- `flutter run` starts the mobile app.
- `flutter analyze` runs Flutter lint checks.
- `flutter test` runs Flutter tests when test files are present.

From `backend/`:

- `go mod tidy` synchronizes Go dependencies.
- `make` or `make run-with-docs` runs `swag init`, then starts the API.
- `make run` starts the API without regenerating docs.
- `make build` builds the `go-routine` binary.
- `make test` runs `go test ./...`.
- `make docs` regenerates Swagger only.

## Coding Style & Naming Conventions
Use `gofmt` for Go and keep package names short and lowercase. Backend handler files use feature folders plus action names, for example `handler/tasks/createTaskRule.go`; follow that pattern for endpoints. Dart follows `flutter_lints`; use `snake_case.dart` filenames, `PascalCase` classes, and `camelCase` members. Keep shared UI in `app/lib/widgets/` and API calls in `app/lib/services/`.

## Testing Guidelines
Backend tests should be Go `*_test.go` files near the package under test and pass with `make test`. Flutter tests should live under `app/test/` as `*_test.dart` and run with `flutter test`. Add focused tests for new handlers, services, parsing logic, and view models; document manual mobile checks in the pull request.

## Commit & Pull Request Guidelines
Recent commits are short and informal, such as `fixes` and `Update README.md`. Keep future subjects concise but more specific, for example `fix task status update` or `add meal search validation`. Pull requests should include a summary, test results (`make test`, `flutter analyze`, `flutter test` as relevant), linked issues, and screenshots or recordings for UI changes.

## Security & Configuration Tips
Do not commit `.env` files or secrets; they are ignored by `.gitignore`. Backend configuration belongs in `backend/.env`, and frontend configuration belongs in `app/.env`. Keep GPT, Nutritionix, exercises, PostgreSQL, and Supabase keys outside source control.
