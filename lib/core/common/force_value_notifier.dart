import 'package:flutter/foundation.dart';

/// A [ValueNotifier] that can also notify listeners when the incoming value
/// is equal to the current value.
class ForceValueNotifier<T> extends ValueNotifier<T> {
  ForceValueNotifier(super.value);

  void setAndNotify(T newValue) {
    if (value == newValue) {
      notifyListeners();
      return;
    }
    value = newValue;
  }
}
