import 'package:flutter/foundation.dart';

void printLog({required String message}) {
  if (kDebugMode) {
    print(message);
  }
}
