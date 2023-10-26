// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

import 'hr_approval_entity.dart';

class RequestDetailsEntity extends BaseEntity {
  String? action;
  String? user;
  String? question;
  String? rejectedBy;
  String? employeeName;
  String? employeeNumber;
  String? submittedDate;
  String? absenceStatus;
  String? absenceType;
  String? absenceCategory;
  String? dateStart;
  String? dateEnd;
  String? days;
  List<HrApprovalEntity> notificationDetails = [];
  List<String> approversList = [];

  RequestDetailsEntity();

  @override
  List<Object?> get props => [action, user, question];
}
