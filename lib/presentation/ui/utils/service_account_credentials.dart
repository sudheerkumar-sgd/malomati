/// Firebase / FCM **server** credentials must not live in the presentation layer.
///
/// Use [FcmCredentials] (`--dart-define`) and [GoogleFcmServiceAccount] from
/// `package:malomati/core/config/` instead. See [doc/FCM_CREDENTIALS.md](../../../../doc/FCM_CREDENTIALS.md).
///
/// This file re-exports the secure API so any legacy import path stays valid without secrets.
/// Project doc: `doc/FCM_CREDENTIALS.md`.

export 'package:malomati/core/config/fcm_credentials.dart';
export 'package:malomati/core/config/google_fcm_service_account.dart';
