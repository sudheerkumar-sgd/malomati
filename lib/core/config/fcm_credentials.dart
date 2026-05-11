/// FCM server-to-server credentials via `--dart-define` only (never commit secrets).
///
/// **Option A — three defines**
/// `FCM_SERVICE_ACCOUNT_EMAIL`, `FCM_OAUTH_CLIENT_ID`, `FCM_PRIVATE_KEY_PEM`
/// ([privateKeyPem] newlines as `\n` in the define value).
///
/// **Option B — one define (recommended for CI / local runs)**  
/// `FCM_SERVICE_ACCOUNT_JSON_BASE64`: base64 (standard, not URL-safe) of the
/// Firebase/Google **service account JSON** file (contains `client_email`,
/// `client_id`, `private_key`).
///
/// See `doc/FCM_CREDENTIALS.md`.
///
/// **Android Studio / Gradle:** values are only visible after a **full rebuild** if they
/// reach the Dart compiler. Use `android/fcm.local.properties` (see example file there)
/// so Gradle merges them into `dart-defines`, or pass `--dart-define-from-file` / defines
/// when using `flutter run`.
class FcmCredentials {
  FcmCredentials._();

  static const String serviceAccountEmail = String.fromEnvironment(
    'FCM_SERVICE_ACCOUNT_EMAIL',
    defaultValue: '',
  );

  static const String oauthClientId = String.fromEnvironment(
    'FCM_OAUTH_CLIENT_ID',
    defaultValue: '',
  );

  /// PEM including BEGIN/END lines; newlines as `\n` in dart-define.
  static const String privateKeyPem = String.fromEnvironment(
    'FCM_PRIVATE_KEY_PEM',
    defaultValue: '',
  );

  /// Full service-account JSON file, base64-encoded (see docs).
  static const String serviceAccountJsonBase64 = String.fromEnvironment(
    'FCM_SERVICE_ACCOUNT_JSON_BASE64',
    defaultValue: '',
  );

  static bool get isSeparateFieldsConfigured =>
      serviceAccountEmail.isNotEmpty &&
      oauthClientId.isNotEmpty &&
      privateKeyPem.isNotEmpty;

  static bool get isJsonBase64Configured => serviceAccountJsonBase64.isNotEmpty;

  static bool get isConfigured =>
      isSeparateFieldsConfigured || isJsonBase64Configured;
}
