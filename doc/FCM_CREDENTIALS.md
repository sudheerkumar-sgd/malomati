# FCM server credentials

The app does not embed a service-account private key in source. Code reads defines via [`FcmCredentials`](../lib/core/config/fcm_credentials.dart) and obtains tokens via [`GoogleFcmServiceAccount`](../lib/core/config/google_fcm_service_account.dart) (used by `RemoteDataSourceImpl.getFCMAccessToken` and push sends). The presentation barrel [`service_account_credentials.dart`](../lib/presentation/ui/utils/service_account_credentials.dart) only re-exports those types—do not add secrets there.

## Option A — three defines

- `FCM_SERVICE_ACCOUNT_EMAIL` — service account email.
- `FCM_OAUTH_CLIENT_ID` — OAuth client id (digits string used by `googleapis_auth`).
- `FCM_PRIVATE_KEY_PEM` — PEM text; use `\n` for newlines inside the define value.

```bash
flutter run \
  --dart-define=FCM_SERVICE_ACCOUNT_EMAIL=firebase-adminsdk-xxx@project.iam.gserviceaccount.com \
  --dart-define=FCM_OAUTH_CLIENT_ID=123456789 \
  --dart-define=FCM_PRIVATE_KEY_PEM=-----BEGIN PRIVATE KEY-----\\nMIIE...\\n-----END PRIVATE KEY-----\\n
```

## Option B — one define (easiest; same JSON file from Firebase Console)

Download **Project settings → Service accounts → Generate new private key** (JSON file). Then pass its **base64** (single line) as:

- `FCM_SERVICE_ACCOUNT_JSON_BASE64`

The JSON must include `client_email`, `client_id`, and `private_key` (standard Google format).

**Linux / macOS:**

```bash
B64=$(base64 -w0 service-account.json)
flutter run --dart-define=FCM_SERVICE_ACCOUNT_JSON_BASE64=$B64
```

**Windows (PowerShell):**

```powershell
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\service-account.json"))
flutter run --dart-define=FCM_SERVICE_ACCOUNT_JSON_BASE64=$b64
```

If credentials are missing or invalid, push calls fail with a clear `ServerException` message instead of an obscure error.

## Fix: “FCM is not configured” / `FcmCredentials.isConfigured` always false

`String.fromEnvironment` is filled only when the **Dart compiler** receives `dart-defines`. If you open the app only from **Android Studio Run** (Gradle) or omit defines on `flutter run`, every value stays empty and `isConfigured` is false until you fix the build.

### Option C — Android Studio / Gradle (`isConfigured` stays false otherwise)

1. Copy [`android/fcm.local.properties.example`](../android/fcm.local.properties.example) → `android/fcm.local.properties` (this path is **gitignored**).
2. Set `fcm.service.account.json.base64` to the same base64 as in Option B.
3. **Build → Clean Project**, then **Rebuild** (or `flutter clean` then run). Hot restart is not enough for `fromEnvironment`.

Gradle merges this into Flutter’s `dart-defines` in [`android/app/build.gradle`](../android/app/build.gradle).

### Option D — JSON file next to `pubspec.yaml` (Cursor / VS Code / `flutter run`)

1. Copy [`fcm_dart_defines.example.json`](../fcm_dart_defines.example.json) → `fcm_dart_defines.json` in the **project root** (same folder as `pubspec.yaml`).
2. Set `FCM_SERVICE_ACCOUNT_JSON_BASE64` to the base64 of your Firebase **service account** JSON (see Option B above). `fcm_dart_defines.json` is **gitignored** — do not commit it.
3. Run Flutter with:

   ```bash
   flutter run --dart-define-from-file=fcm_dart_defines.json --flavor development -t lib/main_development.dart
   ```

   Match `-t` and `--flavor` to how you usually run the app.

4. Optionally add a VS Code launch configuration with extra `args`: `"--dart-define-from-file", "fcm_dart_defines.json"` (see Option D above).

### Option E — iOS / Xcode (when you press Run in Xcode without `flutter run`)

On iOS, `String.fromEnvironment` is filled only if **`DART_DEFINES`** reaches the Flutter build. Xcode does not read `android/fcm.local.properties` or your root `fcm_dart_defines.json` by itself.

**E1 — Prefer Flutter CLI (simplest)**  

From the repo root (macOS), same as Android:

```bash
flutter run --dart-define-from-file=fcm_dart_defines.json
# or
flutter build ios --dart-define-from-file=fcm_dart_defines.json
```

Use the flavors / `-t lib/main_....dart` you normally use. Then open Xcode only to archive or use the already-built product as needed.

**E2 — Xcode-only: optional `xcconfig` (local file, gitignored)**  

1. Copy [`ios/Flutter/fcm-dart-defines.xcconfig.example`](../ios/Flutter/fcm-dart-defines.xcconfig.example) → `ios/Flutter/fcm-dart-defines.xcconfig`.
2. Follow the comments in that file: append one comma-separated **segment** to `DART_DEFINES`, where each segment is **Base64** of the UTF‑8 string  
   `FCM_SERVICE_ACCOUNT_JSON_BASE64=<your json-file base64>` (same long base64 as Option B).
3. [`Debug.xcconfig`](../ios/Flutter/Debug.xcconfig) and [`Release.xcconfig`](../ios/Flutter/Release.xcconfig) already include `#include? "fcm-dart-defines.xcconfig"` **after** `Generated.xcconfig`, so your line `DART_DEFINES=$(DART_DEFINES),…` merges with Flutter’s defines.
4. **Product → Clean Build Folder**, then build again. Hot reload does not refresh `fromEnvironment`.

**E3 — Xcode scheme (advanced)**  

You can set a **User-Defined** setting or pass `DART_DEFINES` via the environment, but it must use Flutter’s format (comma-separated Base64-encoded `KEY=value` chunks). The `xcconfig` approach (E2) is usually easier to maintain.

**CI / TestFlight**  

Use `flutter build ipa` (or `flutter build ios --release`) **with** `--dart-define` / `--dart-define-from-file`, or generate a non-committed `fcm-dart-defines.xcconfig` on the CI machine before `xcodebuild`. Do not commit service-account JSON or keys.

### APK / Play build

`flutter build apk` **must** include the same `--dart-define` or `--dart-define-from-file` (or use `android/fcm.local.properties`); otherwise installs will behave as “FCM not configured”.
