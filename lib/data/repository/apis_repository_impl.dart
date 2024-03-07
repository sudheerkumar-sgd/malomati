import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/data_sources/remote_data_source.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/attendance_List_model.dart';
import 'package:malomati/data/model/attendance_user_details_model.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/data/model/dashboard_model.dart';
import 'package:malomati/data/model/event_list_model.dart';
import 'package:malomati/data/model/leave_submit_response_model.dart';
import 'package:malomati/data/model/leave_type_list_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/data/model/profile_model.dart';
import 'package:malomati/data/model/response_models.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/invoice_list_entity.dart';
import 'package:malomati/domain/entities/leave_submit_response_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';
import 'package:malomati/domain/entities/request_details_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';

import '../../config/constant_config.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/attendance_list_entity.dart';
import '../../domain/entities/hrapproval_details_entity.dart';
import '../../domain/entities/leave_details_entity.dart';
import '../../domain/entities/warning_list_entity.dart';
import '../../domain/repository/apis_repository.dart';
import '../../injection_container.dart';

class ApisRepositoryImpl extends ApisRepository {
  final RemoteDataSource dataSource;
  final NetworkInfo networkInfo;
  ApisRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath,
      required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.login(
            apiPath: apiPath, requestParams: requestParams);
        final apiEntity = apiResponse
            .toEntity<LoginEntity>(apiResponse.data!.toLoginEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.error?.toString() ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<ProfileEntity>>> getProfile(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getProfile(requestParams: requestParams);
        final apiEntity = apiResponse
            .toEntity<ProfileEntity>(apiResponse.data!.toProfileEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.toString()));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getAttendance(requestParams: requestParams);
        final apiEntity = apiResponse.toEntity<AttendanceListEntity>(
            apiResponse.data!.toAttendanceList());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getAttendanceDetails(requestParams: requestParams);
        final apiEntity = apiResponse.toEntity<AttendanceListEntity>(
            apiResponse.data!.toAttendanceList());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<AttendanceUserDetailsEntity>>>
      getAttendanceUserDetails(
          {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getAttendanceUserDetails(
            requestParams: requestParams);
        final apiEntity = apiResponse.toEntity<AttendanceUserDetailsEntity>(
            apiResponse.data!.toAttendanceUserDetailsEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, String>> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.submitAttendanceDetails(
            requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getDashboardData(requestParams: requestParams);
        final apiEntity = apiResponse
            .toEntity<DashboardEntity>(apiResponse.data!.toDashboardEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<EventsListEntity>>> getEventsData(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getEventsData(requestParams: requestParams);
        final apiEntity = apiResponse
            .toEntity<EventsListEntity>(apiResponse.data!.toEventsListEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    try {
      final leaveTypeJson = sl<ConstantConfig>().leaveTypes;
      final list = LeaveTypeListModel.fromJson(leaveTypeJson).toleaveTypeList();
      return Right(list);
    } on DioException catch (error) {
      return Left(ServerFailure(error.message ?? ''));
    } catch (error) {
      return Left(Exception(error.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitLeaveRequest({required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.submitLeaveRequest(requestParams: requestParams);
        final apiEntity = apiResponse.toEntity<LeaveSubmitResponseEntity>(
            apiResponse.data!.toLeaveSubmitResponseEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitServicesRequest(
          {required String apiUrl,
          required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.submitServicesRequest(
            apiUrl: apiUrl, requestParams: requestParams);
        final apiEntity = apiResponse.toEntity<LeaveSubmitResponseEntity>(
            apiResponse.data!.toLeaveSubmitResponseEntity());
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getEmployeesByDepartment(
            requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getEmployeesByManager(
            requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveDetailsEntity>>> getLeaves(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getLeaves(
            apiUrl: apiUrl, requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<HrApprovalEntity>>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getHrApprovalsList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, HrapprovalDetailsEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getHrApprovalDetails(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<FinanceApprovalEntity>>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getFinanceApprovalList(
            apiUrl: apiUrl, requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, HrapprovalDetailsEntity>> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getFinanceItemDetailsList(
            apiUrl: apiUrl, requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PayslipEntity>> getPayslipDetails(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getPayslipDetails(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, WorkingDaysEntity>> getWorkingDays(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getWorkingDays(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitHrApproval({required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.submitHrApproval(requestParams: requestParams);
        return Right(apiResponse.toEntity<LeaveSubmitResponseEntity>(
            apiResponse.data!.toLeaveSubmitResponseEntity()));
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ThankyouEntity>>> getThankyouList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getThankyouList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getRequestsCount(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<FinanceApprovalEntity>>> getNotificationsList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getNotificationsList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventsEntity>>> getHolidaysList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getHolidaysList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendPushNotifications(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.sendPushNotifications(
            requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.submitJobEmailRequest(
            requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherReport(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getWeatherReport(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<WarningListEntity>>> getWarningList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getWarningList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<FinanceApprovalEntity>>> getRequestsList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getRequestsList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, RequestDetailsEntity>> getRequestlDetails(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getRequestlDetails(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<InvoiceListEntity>>> getInvoicesList(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse =
            await dataSource.getInvoicesList(requestParams: requestParams);
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<NameIdEntity>>> getDelegationTypes(
      {required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.get(
            apiUrl: delegationTypesApiUrl, requestParams: requestParams);
        if (apiResponse?['DelegationTypes'] != null) {
          var delegationTypesJson = apiResponse?['DelegationTypes'] as List;
          var delegationTypes = delegationTypesJson
              .map((invoiceJson) =>
                  NameValueModel.fromVactionTypesJson(invoiceJson)
                      .toNameIdEntity())
              .toList();
          return Right(delegationTypes);
        } else {
          return const Right([]);
        }
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> get<T extends BaseModel>({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  }) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.get(
          apiUrl: apiUrl,
          requestParams: requestParams,
        );
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> post<T extends BaseModel>({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  }) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.post(
          apiUrl: apiUrl,
          requestParams: requestParams,
        );
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
