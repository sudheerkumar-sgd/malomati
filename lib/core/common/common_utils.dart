import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openMapsSheet(
    BuildContext context, String title, double lat, double lang) async {
  try {
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.length > 1) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ListTile(
                          onTap: () => map.showMarker(
                            coords: Coords(lat, lang),
                            title: title,
                          ),
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      await availableMaps.first.showMarker(
        coords: Coords(lat, lang),
        title: title,
      );
    }
  } catch (e) {
    print(e);
  }
}

Future<void> launchMapUrl(
    BuildContext context, String title, double lat, double long) async {
  final availableMaps = await MapLauncher.installedMaps;
  await availableMaps.first.showMarker(
    coords: Coords(lat, long),
    title: title,
  );
}

callNumber(BuildContext context, String number) async {
  final result = await FlutterPhoneDirectCaller.callNumber(number);
  if (result == false && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(child: Text('could_not_launch_this_app')),
    ));
  }
}

sendEmail(BuildContext context, String email) async {
  final result =
      await launchUrl(Uri.parse("mailto:${Uri.encodeComponent(email)}"));
  if (result == false && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(child: Text('could_not_launch_this_app')),
    ));
  }
}

double distance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371;
  final dLat = deg2rad(lat2 - lat1);
  final dLon = deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final d = R * c;
  return d;
}

double deg2rad(deg) {
  return deg * (pi / 180);
}

Map getDepartmentByLocation(double lat, double long) {
  Map departmentsLocation = {};
  for (var departments in departmentsLocations) {
    var departmentDistance = distance(
            double.parse(departments['latitude'] as String),
            double.parse(departments['longitude'] as String),
            lat,
            long) *
        1000;
    if (departmentDistance <= (departments['radius'] as int)) {
      departmentsLocation = departments;
      break;
    }
  }
  return departmentsLocation;
}

String getCurrentDateByformat(String format) {
  return DateFormat(format).format(DateTime.now());
}

String getDateByformat(String format, DateTime dateTime) {
  return DateFormat(format).format(dateTime);
}

DateTime getDateTimeByString(String format, String date) {
  return DateFormat(format).parse(date);
}

startTimer({required double duration, required Function callback}) {
  Timer.periodic(const Duration(seconds: 1), (Timer t) => callback());
}

int daysBetween(DateTime from, DateTime to) {
  return (to.difference(from).inSeconds);
}

int getHours(DateTime from, DateTime to) {
  return (daysBetween(from, to) / (60 * 60)).round();
}

int getMinutes(DateTime from, DateTime to) {
  return (daysBetween(from, to) / (60)).round();
}

String getHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = getMinutes(from, to);
  return '${(minutes / 60).round()}.${minutes % 60} hrs';
}

String getRemainingHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = 480 - getMinutes(from, to);
  if (minutes < 1) {
    return '0';
  }
  return '${(minutes / 60).round()}.${minutes % 60} hrs';
}
