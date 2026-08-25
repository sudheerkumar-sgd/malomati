import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// 256-bit Hive key, wrapped by Android Keystore / iOS Keychain (AES-GCM).
class LocalCryptoKey {
  static const _channel = MethodChannel('malomati/local_crypto');

  static Uint8List? _cached;

  static Future<Uint8List> getHiveKey() async {
    if (_cached != null) return _cached!;
    try {
      final result = await _channel.invokeMethod<dynamic>('getHiveKey');
      final bytes = _asBytes(result);
      if (bytes != null && bytes.length == 32) {
        _cached = bytes;
        return bytes;
      }
    } on MissingPluginException {
      // ponytail: unit tests — ephemeral key, box does not persist
    }
    _cached = Uint8List.fromList(Hive.generateSecureKey());
    return _cached!;
  }

  static Uint8List? _asBytes(dynamic result) {
    if (result is Uint8List) return result;
    if (result is List) return Uint8List.fromList(result.cast<int>());
    return null;
  }
}
