# Alpha

Alpha is a Flutter application for a digital asset platform. The app includes authentication, market data, trading, wallet assets, deposits, withdrawals, staking, earn products, referrals, announcements, profile management, localization, and real-time socket features.

https://github.com/user-attachments/assets/7a254efe-5818-49b8-9590-7b036414bd73

## Tech Stack

- Flutter with Dart SDK `^3.8.1`
- Provider for state management
- GetIt for dependency injection
- GoRouter for navigation
- Dio and Retrofit for API access
- Hive and Flutter Secure Storage for local persistence
- Flutter localization with ARB files
- Freezed, Json Serializable, Retrofit Generator, and Hive Generator for generated code

## Project Structure

```text
lib/
  core/                 Shared constants, networking, widgets, mixins, utilities, localization
  data/                 Models, repositories, API services, local services, mock data
  domain/               Use cases
  env/                  Environment templates
  injection/            Dependency injection setup
  presentation/         Screens and view models
  routers/              App routes and route names
assets/
  fonts/                IBM Plex Sans font files
  icons/                SVG icon assets
  images/               Image assets
scripts/                Build, environment, and code generation scripts
test/                   Flutter tests
```

## Requirements

Install these tools before running the project:

- Flutter SDK compatible with Dart `^3.8.1`
- Android Studio or Xcode for mobile builds
- CocoaPods for iOS builds on macOS
- A configured Android emulator, iOS simulator, or physical device

Check your local setup:

```bash
flutter doctor
flutter --version
```

## Environment Configuration

The app reads environment values from a root `.env` file through `flutter_dotenv`.

Required keys:

```env
BASE_URL=
SOCKET_URL_PRIVATE=
SOCKET_URL_PUBLIC=
SHARE_URL=
WEBVIEW_URL=
```

Environment templates are stored in:

- `lib/env/.env.development`
- `lib/env/.env.production`

Create the root `.env` file with one of these commands:

```bash
./scripts/setup_env.sh development
```

```bash
./scripts/setup_env.sh production
```

You can also copy a template manually:

```bash
cp lib/env/.env.development .env
```

Do not commit local secrets or private environment values.

## Installation

Install Flutter dependencies:

```bash
flutter pub get
```

Generate localization files:

```bash
flutter gen-l10n
```

Generate code for Freezed, JSON serialization, Retrofit, and Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use the project script:

```bash
./scripts/build_runner.sh
```

## Run the App

Run on the currently selected device:

```bash
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

Common targets:

```bash
flutter run -d chrome
flutter run -d <android-device-id>
flutter run -d <ios-device-id>
```

If the app cannot load environment values, recreate `.env` before running:

```bash
./scripts/setup_env.sh development
flutter run
```

## Testing and Analysis

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Format Dart code:

```bash
dart format lib test
```

## Build

### Build with Flutter Commands

Android APK:

```bash
flutter build apk --release --target-platform android-arm64
```

Android App Bundle:

```bash
flutter build appbundle --release
```

iOS build without code signing:

```bash
flutter build ios --release --no-codesign
```

Web build:

```bash
flutter build web --release
```

### Build with Project Scripts

Development build:

```bash
./scripts/build_dev.sh android
./scripts/build_dev.sh ios
./scripts/build_dev.sh web
./scripts/build_dev.sh all
```

Production build:

```bash
./scripts/build_prod.sh android
./scripts/build_prod.sh ios
./scripts/build_prod.sh web
./scripts/build_prod.sh all
```

Advanced environment build:

```bash
./scripts/build_with_env.sh dev --apk
./scripts/build_with_env.sh prod --all
./scripts/build_with_env.sh dev --clean
```

Build all environments:

```bash
./scripts/build_all.sh
```

Build outputs are written under `build/`. APK scripts rename generated files with an environment name and timestamp.

## Localization

Localization source files live in:

```text
lib/core/utils/lang/config/
```

The localization config is defined in `l10n.yaml`:

- Template file: `app_en.arb`
- Generated output: `app_locale_language.dart`

Regenerate localization after editing ARB files:

```bash
flutter gen-l10n
```

## Generated Code

This project uses generated files for models and API clients. Regenerate them after editing annotated model, Retrofit, Freezed, or Hive files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Use watch mode during active development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## App Entry Points

- Main entry: `lib/main.dart`
- Dependency injection: `lib/injection/injector.dart`
- Router setup: `lib/routers/app_route.dart`
- Environment access: `lib/core/env/env.dart`

## Troubleshooting

If dependencies or generated files are stale:

```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
```

If iOS dependencies fail:

```bash
cd ios
pod install
cd ..
```

If environment values are missing:

```bash
./scripts/setup_env.sh development
```

If localization classes are missing:

```bash
flutter gen-l10n
```
