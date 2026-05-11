import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';

import 'fcm_credentials.dart';

/// Builds Google OAuth2 credentials for FCM HTTP v1 (server-to-server).
///
/// Values come only from `--dart-define` (see [FcmCredentials] and `doc/FCM_CREDENTIALS.md`).
/// Never embed private keys or tokens in source.
class GoogleFcmServiceAccount {
  GoogleFcmServiceAccount._();

  static const List<String> messagingScopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  /// Throws [StateError] if [FcmCredentials.isConfigured] is false or JSON is invalid.
  static ServiceAccountCredentials messagingServiceAccountCredentials() {
    if (FcmCredentials.isJsonBase64Configured) {
      return _credentialsFromServiceAccountJsonBase64(
        FcmCredentials.serviceAccountJsonBase64,
      );
    }
    if (FcmCredentials.isSeparateFieldsConfigured) {
      return ServiceAccountCredentials(
        FcmCredentials.serviceAccountEmail,
        ClientId(FcmCredentials.oauthClientId),
        FcmCredentials.privateKeyPem.replaceAll(r'\n', '\n'),
      );
    }
    throw StateError(
      'FCM credentials missing. Use either:\n'
      '  --dart-define=FCM_SERVICE_ACCOUNT_JSON_BASE64=<base64 of service-account.json>\n'
      'or all of:\n'
      '  --dart-define=FCM_SERVICE_ACCOUNT_EMAIL=... '
      '--dart-define=FCM_OAUTH_CLIENT_ID=... '
      '--dart-define=FCM_PRIVATE_KEY_PEM=... (use \\n for PEM newlines)\n'
      'See doc/FCM_CREDENTIALS.md',
    );
  }

  static ServiceAccountCredentials _credentialsFromServiceAccountJsonBase64(
    String b64,
  ) {
    try {
      final normalized = _normalizeBase64(b64);
      final jsonBytes = base64Decode(normalized);
      final Map<String, dynamic> map;
      try {
        map = jsonDecode(utf8.decode(jsonBytes)) as Map<String, dynamic>;
      } on FormatException catch (e) {
        throw StateError(
          'FCM_SERVICE_ACCOUNT_JSON_BASE64 decodes to invalid JSON: $e',
        );
      }
      final email = map['client_email'] as String?;
      final clientId = map['client_id']?.toString();
      final privateKey = map['private_key'] as String?;
      if (email == null ||
          clientId == null ||
          privateKey == null ||
          email.isEmpty ||
          clientId.isEmpty ||
          privateKey.isEmpty) {
        throw StateError(
          'FCM_SERVICE_ACCOUNT_JSON_BASE64 must decode to JSON with '
          'non-empty client_email, client_id, and private_key.',
        );
      }
      return ServiceAccountCredentials(
        email,
        ClientId(clientId),
        privateKey,
      );
    } on FormatException catch (e) {
      throw StateError(
        'FCM_SERVICE_ACCOUNT_JSON_BASE64 is not valid base64: $e',
      );
    }
  }

  static String _normalizeBase64(String input) {
    var s = input.trim().replaceAll(RegExp(r'\s+'), '');
    final pad = s.length % 4;
    if (pad != 0) {
      s = s.padRight(s.length + (4 - pad), '=');
    }
    return s;
  }

  static Future<AccessToken> obtainMessagingAccessToken() async {
    final client = await clientViaServiceAccount(
      messagingServiceAccountCredentials(),
      messagingScopes,
    );
    return client.credentials.accessToken;
  }
}
