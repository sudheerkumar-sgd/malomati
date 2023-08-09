// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class AttendanceEntity extends BaseEntity {
  String? userid;
  String? username;
  String? processdate;
  String? punch1Time;
  String? punch2Time;

  AttendanceEntity();
  @override
  List<Object?> get props =>
      [userid, username, processdate, punch1Time, punch2Time];
}
