import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malomati/presentation/ui/widgets/security_alert_dialog_widget.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

import '../../presentation/ui/widgets/alert_dialog_widget.dart';

class SecurityCheck {
  static const MethodChannel _channel = MethodChannel('security_check');

  Future<bool> isTampered() async {
    final bool result = await _channel.invokeMethod('isTampered');
    return result;
  }

  void checkSecurity(BuildContext context) async {
    String message = '';
    if (Platform.isAndroid) {
      if (await isDeviceTampered()) {
        message = "⚠️ Security tool detected!";
      } else if (await isDeviceRooted()) {
        message = "⚠️ Device root detected!";
      } else if (await isdeveloperMode()) {
        message = "⚠️ Device DeveloperMode detected!";
      }
    } else if (Platform.isIOS && await isJailbreak()) {
      message = "⚠️ Device Jailbreak detected!";
    }
    if (message.isNotEmpty && context.mounted) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
                canPop: false,
                onPopInvokedWithResult: (did, obj) async => false,
                child: SecurityDialogWidget(
                  message: message,
                  type: PopupType.fail,
                ));
          });
    }
  }

  Future<bool> isDeviceTampered() async {
    try {
      return await isTampered();
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isDeviceRooted() async {
    try {
      return (await RootCheckerPlus.isRootChecker()) ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isdeveloperMode() async {
    try {
      return await RootCheckerPlus.isDeveloperMode() ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isJailbreak() async {
    try {
      return await RootCheckerPlus.isJailbreak() ?? false;
    } on PlatformException {
      return false;
    }
  }
}
