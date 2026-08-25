import 'dart:math';
import 'dart:typed_data';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pointycastle/export.dart';

/// AES-256-GCM (AEAD) Hive cipher. 12-byte IV per encrypt, 128-bit auth tag.
///
/// Replaces Hive's default [HiveAesCipher] (AES-CBC without HMAC).
class AesGcmHiveCipher implements HiveCipher {
  static const int ivLength = 12;
  static const int tagLength = 16;
  static const int _tagBits = 128;

  static final _ivRandom = Random.secure();

  final Uint8List _key;
  final int _keyCrc;

  AesGcmHiveCipher(List<int> key)
      : _key = Uint8List.fromList(key),
        _keyCrc = _crc32(Uint8List.fromList(key)) {
    if (_key.length != 32 || _key.any((b) => b < 0 || b > 255)) {
      throw ArgumentError('AES-256-GCM key must be 32 bytes.');
    }
  }

  @override
  int calculateKeyCrc() => _keyCrc;

  @override
  int maxEncryptedSize(Uint8List inp) => inp.length + ivLength + tagLength;

  @override
  int encrypt(
    Uint8List inp,
    int inpOff,
    int inpLength,
    Uint8List out,
    int outOff,
  ) {
    final iv = _randomIv();
    final plain = Uint8List.fromList(
      Uint8List.sublistView(inp, inpOff, inpOff + inpLength),
    );
    final sealed = _gcm(encrypt: true, iv: iv).process(plain);
    out.setRange(outOff, outOff + ivLength, iv);
    out.setRange(outOff + ivLength, outOff + ivLength + sealed.length, sealed);
    return ivLength + sealed.length;
  }

  @override
  int decrypt(
    Uint8List inp,
    int inpOff,
    int inpLength,
    Uint8List out,
    int outOff,
  ) {
    if (inpLength < ivLength + tagLength) {
      throw StateError('Ciphertext too short for AES-GCM.');
    }
    final iv = Uint8List.sublistView(inp, inpOff, inpOff + ivLength);
    final sealed = Uint8List.sublistView(
      inp,
      inpOff + ivLength,
      inpOff + inpLength,
    );
    final plain = _gcm(encrypt: false, iv: Uint8List.fromList(iv)).process(
      Uint8List.fromList(sealed),
    );
    out.setRange(outOff, outOff + plain.length, plain);
    return plain.length;
  }

  GCMBlockCipher _gcm({required bool encrypt, required Uint8List iv}) {
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      encrypt,
      AEADParameters(KeyParameter(_key), _tagBits, iv, Uint8List(0)),
    );
    return cipher;
  }

  Uint8List _randomIv() {
    final iv = Uint8List(ivLength);
    for (var i = 0; i < ivLength; i++) {
      iv[i] = _ivRandom.nextInt(256);
    }
    return iv;
  }

  static int _crc32(Uint8List bytes) {
    var crc = 0xFFFFFFFF;
    for (final b in bytes) {
      crc ^= b;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
      }
    }
    return crc ^ 0xFFFFFFFF;
  }
}
