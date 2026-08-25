import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:malomati/core/constants/constants.dart';

import 'aes_gcm_hive_cipher.dart';
import 'local_crypto_key.dart';

/// Opens the settings box with AES-256-GCM and migrates the old plaintext box.
class SecureHive {
  static Future<void> init() async {
    await Hive.initFlutter();
    final key = await LocalCryptoKey.getHiveKey();
    await Hive.openBox(
      appSettingsDb,
      encryptionCipher: AesGcmHiveCipher(key),
    );
    await _migrateLegacyPlaintextBox();
  }

  static Future<void> _migrateLegacyPlaintextBox() async {
    if (!await Hive.boxExists(legacyAppSettingsDb)) return;
    final legacy = await Hive.openBox(legacyAppSettingsDb);
    final dest = Hive.box(appSettingsDb);
    for (final key in legacy.keys) {
      if (!dest.containsKey(key)) {
        dest.put(key, legacy.get(key));
      }
    }
    await legacy.deleteFromDisk();
  }
}
