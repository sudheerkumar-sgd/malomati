import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:malomati/core/security/aes_gcm_hive_cipher.dart';
import 'package:pointycastle/export.dart';

void main() {
  final key = List<int>.generate(32, (i) => i + 1);

  Uint8List roundTrip(AesGcmHiveCipher cipher, Uint8List plain) {
    final out = Uint8List(cipher.maxEncryptedSize(plain));
    final encLen = cipher.encrypt(plain, 0, plain.length, out, 0);
    final decrypted = Uint8List(plain.length);
    final decLen = cipher.decrypt(out, 0, encLen, decrypted, 0);
    return Uint8List.sublistView(decrypted, 0, decLen);
  }

  test('AES-256-GCM round-trips and rejects tampered ciphertext', () {
    final cipher = AesGcmHiveCipher(key);
    final plain = Uint8List.fromList('payslip-hr-secret'.codeUnits);
    expect(roundTrip(cipher, plain), plain);

    final out = Uint8List(cipher.maxEncryptedSize(plain));
    final encLen = cipher.encrypt(plain, 0, plain.length, out, 0);
    out[AesGcmHiveCipher.ivLength + 2] ^= 0xFF;
    expect(
      () => cipher.decrypt(out, 0, encLen, Uint8List(plain.length), 0),
      throwsA(isA<InvalidCipherTextException>()),
    );
  });
}
