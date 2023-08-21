import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';

import '../../core/error/failures.dart';
import '../entities/attendance_list_entity.dart';
import '../entities/leave_submit_response_entity.dart';
import '../entities/login_entity.dart';

abstract class ApisRepository {
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath, required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<ProfileEntity>>> getProfile(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, String>> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<EventsListEntity>>> getEventsData(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitLeaveRequest({required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitInitiative({required Map<String, dynamic> requestParams});
}
