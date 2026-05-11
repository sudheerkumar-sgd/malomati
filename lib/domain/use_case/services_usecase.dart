import 'package:dartz/dartz.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/response_models.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/invoice_list_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/repository/services_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';
import '../entities/delegation_category_entity.dart';
import '../entities/hrapproval_details_entity.dart';
import '../entities/leave_details_entity.dart';
import '../entities/leave_submit_response_entity.dart';
import '../entities/warning_list_entity.dart';

class ServicesUseCase extends BaseUseCase {
  final ServicesRepository servicesRepository;
  ServicesUseCase({required this.servicesRepository});

  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getLeaveTypes(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitLeaveRequest({required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.submitLeaveRequest(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitServicesRequest(
          {required String apiUrl,
          required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.submitServicesRequest(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getEmployeesByDepartment(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getEmployeesByManager(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<LeaveDetailsEntity>>> getLeaves(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getLeaves(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, List<HrApprovalEntity>>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getHrApprovalsList(
        requestParams: requestParams);
  }

  Future<Either<Failure, HrapprovalDetailsEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getHrApprovalDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<FinanceApprovalEntity>>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getFinanceApprovalList(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, HrapprovalDetailsEntity>> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getFinanceItemDetailsList(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, PayslipEntity>> getPayslipDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getPayslipDetails(requestParams: requestParams);
  }

  Future<Either<Failure, WorkingDaysEntity>> getWorkingDays(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getWorkingDays(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitHrApproval({required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.submitHrApproval(requestParams: requestParams);
  }

  Future<Either<Failure, List<ThankyouEntity>>> getThankyouList(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getThankyouList(requestParams: requestParams);
  }

  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getRequestsCount(requestParams: requestParams);
  }

  Future<Either<Failure, List<EventsEntity>>> getHolidaysList(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getHolidaysList(requestParams: requestParams);
  }

  Future<Either<Failure, String>> sendPushNotifications(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.sendPushNotifications(
        requestParams: requestParams);
  }

  Future<Either<Failure, Map<String, dynamic>>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.submitJobEmailRequest(
        requestParams: requestParams);
  }

  Future<Either<Failure, List<WarningListEntity>>> getWarningList(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getWarningList(requestParams: requestParams);
  }

  Future<Either<Failure, List<InvoiceListEntity>>> getInvoicesList(
      {required Map<String, dynamic> requestParams}) async {
    return await servicesRepository.getInvoicesList(requestParams: requestParams);
  }

  Future<Either<Failure, List<NameIdEntity>>> getDelegationTypes(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: delegationTypesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromVactionTypesJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(
          (r.toEntity2<ListEntity>().entity?.list ?? []) as List<NameIdEntity>);
    });
  }

  Future<Either<Failure, List<DelegationUserEntity>>> getDelegationUsers(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: delegationUsersApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromDelegationUsersJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ?? [])
          as List<DelegationUserEntity>);
    });
  }

  Future<Either<Failure, List<DelegationCategoryEntity>>>
      getDelegationCategories(
          {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: delegationCategoriesApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromDelegationCategoriesJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ?? [])
          as List<DelegationCategoryEntity>);
    });
  }

  Future<Either<Failure, List<DelegationItemEntity>>> getDelegationList(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: delegationListApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromDelegationListJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ??
          List<DelegationItemEntity>.empty()) as List<DelegationItemEntity>);
    });
  }

  Future<Either<Failure, List<DelegationItemEntity>>> deleteDelegation(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.post<ListModel>(
      apiUrl: delegationDeleteApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromDelegationListJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ?? [])
          as List<DelegationItemEntity>);
    });
  }

  Future<Either<Failure, List<String>>> getResignationReasons(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: resignationReasonsApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromResignationReasonsJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ??
          List<String>.empty()) as List<String>);
    });
  }

  Future<Either<Failure, List<String>>> getTrainingCerttypeList(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await servicesRepository.get<ListModel>(
      apiUrl: trainingCertListApiUrl,
      requestParams: requestParams,
      responseModel: ListModel.fromTrainingCertTypeJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right((r.toEntity2<ListEntity>().entity?.list ??
          List<String>.empty()) as List<String>);
    });
  }
}
