import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:malomati/core/common/log.dart';

class Location {
  static Future<bool> checkGps() async {
    var servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      bool haspermission = false;
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          printLog(message: 'Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          printLog(message: "'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      return haspermission;
    } else {
      printLog(message: "GPS Service is not enabled, turn on GPS location");
      return false;
    }
  }

  static Future<Position> getLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
