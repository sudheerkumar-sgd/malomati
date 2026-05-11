import 'package:dartz/dartz.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/invoice_list_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';

import '../entities/finance_approval_entity.dart';
import '../entities/hrapproval_details_entity.dart';
import '../entities/leave_details_entity.dart';
import '../entities/leave_submit_response_entity.dart';
import '../entities/request_details_entity.dart';
import '../entities/requests_count_entity.dart';
import '../entities/thankyou_entity.dart';
import '../entities/warning_list_entity.dart';

/// Self-service, HR/finance approvals, delegations, and related APIs.
abstract class ServicesRepository {
  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitLeaveRequest({required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitServicesRequest(
          {required String apiUrl,
          required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitGetRequest(
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
  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, HrapprovalDetailsEntity>> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<EventsEntity>>> getHolidaysList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, String>> sendPushNotifications(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, Map<String, dynamic>>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<WarningListEntity>>> getWarningList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getRequestsList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, RequestDetailsEntity>> getRequestlDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<InvoiceListEntity>>> getInvoicesList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<NameIdEntity>>> getDelegationTypes(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiResponse>> get<T extends BaseModel>({
    String? baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  });
  Future<Either<Failure, ApiResponse>> post<T extends BaseModel>({
    String? baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  });
}
