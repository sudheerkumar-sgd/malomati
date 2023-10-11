import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mime/mime.dart';

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
    printLog(message: e.toString());
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

launchAppUrl(String appId) {
  if (Platform.isAndroid || Platform.isIOS) {
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
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
  try {
    return dateTime.year == 0 ? '' : DateFormat(format).format(dateTime);
  } catch (error) {
    return '';
  }
}

DateTime getDateTimeByString(String format, String date) {
  try {
    return DateFormat(format).parse(date);
  } catch (error) {
    return DateTime(0);
  }
}

startTimer({required double duration, required Function callback}) {
  Timer.periodic(const Duration(seconds: 1), (Timer t) => callback());
}

int daysBetween(DateTime from, DateTime to) {
  return (to.difference(from).inSeconds);
}

int getDays(DateTime from, DateTime to) {
  return getHours(from, to) ~/ 24;
}

int getHours(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60 * 60);
}

int getMinutes(DateTime from, DateTime to) {
  return daysBetween(from, to) ~/ (60);
}

String getHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = getMinutes(from, to);
  return '${minutes ~/ 60}.${minutes % 60} hrs';
}

String getRemainingHoursMinutesFormat(DateTime from, DateTime to) {
  var minutes = 480 - getMinutes(from, to);
  if (minutes < 1) {
    return '0';
  }
  return '${(minutes ~/ 60)}.${minutes % 60} hrs';
}

List<NameIdEntity> getDropDownYesNo(BuildContext context) {
  return [
    NameIdEntity('Y', context.string.yes),
    NameIdEntity('N', context.string.no)
  ];
}

List<NameIdEntity> getSalaryTypes(BuildContext context) {
  return [
    NameIdEntity('D', context.string.detailedSalary),
    NameIdEntity('N', context.string.noSalary),
    NameIdEntity('Y', context.string.totalSalary)
  ];
}

logout(BuildContext context) {
  FirebaseMessaging.instance
      .unsubscribeFromTopic(context.userDB.get(userNameKey, defaultValue: 'a'));
  context.userDB.delete(isGuestKey);
  context.userDB.delete(oracleLoginIdKey);
  context.userDB.delete(userFullNameUsKey);
  context.userDB.delete(userFullNameArKey);
  context.userDB.delete(isMaangerKey);
  context.userDB.delete(favoriteKey);
  Phoenix.rebirth(context);
}

bool isImage(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('image/') ?? false;
}

bool isPdf(String path) {
  final mimeType = lookupMimeType(path);

  return mimeType?.startsWith('application/pdf') ?? false;
}

double getTopSafeAreaHeight(BuildContext context) {
  printLog(message: '${MediaQuery.of(context).padding.top}');
  return MediaQuery.of(context).padding.top;
}

Size getScrrenSize(BuildContext context) {
  printLog(message: '${MediaQuery.of(context).size}');
  return MediaQuery.of(context).size;
}

Map<String, dynamic> getFCMMessageData(
    {required String to,
    required String title,
    required String body,
    String type = '',
    String notificationId = ''}) {
  return {
    "to": '/topics/$to',
    "notification": {
      "title": title,
      "body": body,
      "click_action": "HR_APPROVALS"
    },
    "data": {
      "title": title,
      "body": body,
      "type": type,
      "notification_id": notificationId
    },
    "priority": "high"
  };
}

String getLeavesApproverFCMBodyText(
    String prefix, String leaveName, String fromDate, String toDate) {
  return '$prefix has applied for $leaveName Request from $fromDate to $toDate';
}

String getWeatherIcon(int weatherCode) {
  switch (weatherCode) {
    case 2 || 3:
      return DrawableAssets.icCloudy; //Cloudy
    //case 45&&48: return DrawableAssets.bgWeather;//Foggy
    case 61 || 63 || 65 || 66 || 67:
      return DrawableAssets.icRain; //Rain
    case 95 || 96 || 99:
      return DrawableAssets.icStorm; //Thunderstorm
    default:
      return DrawableAssets.icSun;
  }
}
