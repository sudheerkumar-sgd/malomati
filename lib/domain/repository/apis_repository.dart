import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';

import '../../core/error/failures.dart';
import '../entities/attendance_list_entity.dart';
import '../entities/finance_approval_entity.dart';
import '../entities/hrapproval_details_entity.dart';
import '../entities/leave_details_entity.dart';
import '../entities/leave_submit_response_entity.dart';
import '../entities/login_entity.dart';
import '../entities/request_details_entity.dart';
import '../entities/requests_count_entity.dart';
import '../entities/thankyou_entity.dart';
import '../entities/warning_list_entity.dart';
import '../entities/weather_entity.dart';

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
      submitServicesRequest(
          {required String apiUrl,
          required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<LeaveDetailsEntity>>> getLeaves(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<HrApprovalEntity>>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, HrapprovalDetailsEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, PayslipEntity>> getPayslipDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, WorkingDaysEntity>> getWorkingDays(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitHrApproval({required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<ThankyouEntity>>> getThankyouList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, HrapprovalDetailsEntity>> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getNotificationsList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<EventsEntity>>> getHolidaysList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, String>> sendPushNotifications(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, Map<String, dynamic>>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, WeatherEntity>> getWeatherReport(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<WarningListEntity>>> getWarningList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getRequestsList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, RequestDetailsEntity>> getRequestlDetails(
      {required Map<String, dynamic> requestParams});
}
