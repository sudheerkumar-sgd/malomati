import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';
import '../entities/hrapproval_details_entity.dart';
import '../entities/leave_details_entity.dart';
import '../entities/leave_submit_response_entity.dart';

class ServicesUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ServicesUseCase({required this.apisRepository});

  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getLeaveTypes(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitLeaveRequest({required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitLeaveRequest(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitServicesRequest(
          {required String apiUrl,
          required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitServicesRequest(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getEmployeesByDepartment(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getEmployeesByManager(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<LeaveDetailsEntity>>> getLeaves(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getLeaves(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, List<HrApprovalEntity>>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getHrApprovalsList(
        requestParams: requestParams);
  }

  Future<Either<Failure, HrapprovalDetailsEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getHrApprovalDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<FinanceApprovalEntity>>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getFinanceApprovalList(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, HrapprovalDetailsEntity>> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getFinanceItemDetailsList(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, PayslipEntity>> getPayslipDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getPayslipDetails(requestParams: requestParams);
  }

  Future<Either<Failure, WorkingDaysEntity>> getWorkingDays(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getWorkingDays(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitHrApproval({required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitHrApproval(requestParams: requestParams);
  }

  Future<Either<Failure, List<ThankyouEntity>>> getThankyouList(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getThankyouList(requestParams: requestParams);
  }

  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getRequestsCount(requestParams: requestParams);
  }

  Future<Either<Failure, List<EventsEntity>>> getHolidaysList(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getHolidaysList(requestParams: requestParams);
  }

  Future<Either<Failure, String>> sendPushNotifications(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.sendPushNotifications(
        requestParams: requestParams);
  }

  Future<Either<Failure, Map<String, dynamic>>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitJobEmailRequest(
        requestParams: requestParams);
  }
}
