import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/model/Leaves_model.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/attendance_user_details_model.dart';
import 'package:malomati/data/model/dashboard_model.dart';
import 'package:malomati/data/model/employee_model.dart';
import 'package:malomati/data/model/event_list_model.dart';
import 'package:malomati/data/model/event_model.dart';
import 'package:malomati/data/model/finance_approval_model.dart';
import 'package:malomati/data/model/hr_approval_model.dart';
import 'package:malomati/data/model/hrapproval_details_model.dart';
import 'package:malomati/data/model/leave_submit_response_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/data/model/payslip_model.dart';
import 'package:malomati/data/model/profile_model.dart';
import 'package:malomati/data/model/requsts_count_model.dart';
import 'package:malomati/data/model/response_models.dart';
import 'package:malomati/data/model/thankyou_model.dart';
import 'package:malomati/data/model/weather_model.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/hrapproval_details_entity.dart';
import 'package:malomati/domain/entities/invoice_list_entity.dart';
import 'package:malomati/domain/entities/leave_details_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/entities/warning_list_entity.dart';
import 'package:malomati/presentation/ui/services/thankyou_screen.dart';
import '../../config/base_url_config.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/request_details_entity.dart';
import '../../domain/entities/requests_count_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../model/attendance_List_model.dart';
import 'api_urls.dart';
import 'dio_logging_interceptor.dart';
import 'package:googleapis_auth/auth_io.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<LoginModel>> login(
      {required apiPath, required Map<String, dynamic> requestParams});
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<AttendanceListModel>> getAttendance(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<AttendanceListModel>> getAttendanceDetails(
      {required Map<String, dynamic> requestParams});
  Future<String> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<AttendanceUserDetailsModel>> getAttendanceUserDetails(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<DashboardModel>> getDashboardData(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<EventListModel>> getEventsData(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitLeaveRequest(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitServicesRequest(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitGetRequest(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<List<EmployeeEntity>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams});
  Future<List<EmployeeEntity>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams});
  Future<List<LeaveDetailsEntity>> getLeaves(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<List<HrApprovalEntity>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams});
  Future<HrapprovalDetailsEntity> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams});
  Future<RequestDetailsEntity> getRequestlDetails(
      {required Map<String, dynamic> requestParams});
  Future<PayslipEntity> getPayslipDetails(
      {required Map<String, dynamic> requestParams});
  Future<WorkingDaysEntity> getWorkingDays(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitHrApproval(
      {required Map<String, dynamic> requestParams});
  Future<List<ThankyouEntity>> getThankyouList(
      {required Map<String, dynamic> requestParams});
  Future<List<FinanceApprovalEntity>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<HrapprovalDetailsEntity> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams});
  Future<RequestsCountEntity> getRequestsCount(
      {required Map<String, dynamic> requestParams});
  Future<List<FinanceApprovalEntity>> getNotificationsList(
      {required Map<String, dynamic> requestParams});
  Future<List<EventsEntity>> getHolidaysList(
      {required Map<String, dynamic> requestParams});
  Future<String> sendPushNotifications(
      {required Map<String, dynamic> requestParams});
  Future<Map<String, dynamic>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams});
  Future<WeatherEntity> getWeatherReport(
      {required Map<String, dynamic> requestParams});
  Future<List<WarningListEntity>> getWarningList(
      {required Map<String, dynamic> requestParams});
  Future<List<FinanceApprovalEntity>> getRequestsList(
      {required Map<String, dynamic> requestParams});
  Future<List<InvoiceListEntity>> getInvoicesList(
      {required Map<String, dynamic> requestParams});
  Future<AccessToken> getFCMAccessToken();
  Future<dynamic> get(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<dynamic> post(
      {required String apiUrl, required Map<String, dynamic> requestParams});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  ServerException _getExceptionType(Response<dynamic> response) {
    switch (response.statusCode) {
      case 400:
        return throw ServerException(message: response.data);
      case 401:
        return throw const ServerException(message: 'Unauthorized');
      case 500:
        return throw const ServerException(message: 'Internal Server Error');
      default:
        throw ServerException(
            message: response.data.isNull ? 'Unknown Error' : response.data);
    }
  }

  @override
  Future<ApiResponse<LoginModel>> login(
      {required apiPath, required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        loginApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );

      var apiResponse = ApiResponse<LoginModel>.fromJson(
          response.data, (p0) => LoginModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        getProfileApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );

      var apiResponse = ApiResponse<ProfileModel>.fromJson(
          response.data, (p0) => ProfileModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AttendanceListModel>> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2
          .get(
            '${attendanceApiUrl}date-range=${requestParams['date-range']}$attendanceRequestedParams',
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: requestParams['oracle_id'],
            }),
          )
          .timeout(const Duration(seconds: 5));

      switch (response.statusCode) {
        case 200:
          var apiResponse = ApiResponse<AttendanceListModel>.fromJson(
              response.data,
              (p0) => AttendanceListModel.fromJson(response.data));
          return apiResponse;
        default:
          throw _getExceptionType(response);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<ApiResponse<AttendanceListModel>> getAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2
          .get(
            '${attendanceDetailsApiUrl}date-range=${requestParams['date-range']}$attendanceDetailsRequestedParams',
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
          )
          .timeout(const Duration(seconds: 5));

      switch (response.statusCode) {
        case 200:
          var apiResponse = ApiResponse<AttendanceListModel>.fromJson(
              response.data,
              (p0) => AttendanceListModel.fromJson(response.data));
          return apiResponse;
        default:
          throw _getExceptionType(response);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<ApiResponse<AttendanceUserDetailsModel>> getAttendanceUserDetails(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2
          .get(
            attendanceUserDetailsApiUrl,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
          )
          .timeout(const Duration(seconds: 5));

      switch (response.statusCode) {
        case 200:
          var apiResponse = ApiResponse<AttendanceUserDetailsModel>.fromJson(
              response.data,
              (p0) => AttendanceUserDetailsModel.fromJson(response.data));
          return apiResponse;
        default:
          throw _getExceptionType(response);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<String> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var query =
          'userid=${requestParams['userid']};event-datetime=${requestParams['date']};in-out=${requestParams['isInOut']};dtype=12;did=1;gps_latitude=${requestParams['latitude']};gps_longitude=${requestParams['longitude']};spfid=${requestParams['method']}';
      var response = await dio2
          .get(
            '$attendanceSubmitApiUrl$query',
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
          )
          .timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 200:
          return response.data;
        default:
          throw _getExceptionType(response);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<ApiResponse<DashboardModel>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        dashboardApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );

      var apiResponse = ApiResponse<DashboardModel>.fromJson(
          response.data, (p0) => DashboardModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<EventListModel>> getEventsData(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        eventApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );

      var apiResponse = ApiResponse<EventListModel>.fromJson(
          response.data, (p0) => EventListModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LeaveSubmitResponseModel>> submitLeaveRequest(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        leaveSubmitApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = ApiResponse<LeaveSubmitResponseModel>.fromJson(
          response.data,
          (p0) => LeaveSubmitResponseModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LeaveSubmitResponseModel>> submitServicesRequest(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        apiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = ApiResponse<LeaveSubmitResponseModel>.fromJson(
          response.data,
          (p0) => LeaveSubmitResponseModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LeaveSubmitResponseModel>> submitGetRequest(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = ApiResponse<LeaveSubmitResponseModel>.fromJson(
          response.data,
          (p0) => LeaveSubmitResponseModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        employeesApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['DeptEmployeesList'] != null) {
        var deptEmployeesListJson = response.data['DeptEmployeesList'] as List;
        var deptEmployeesList = deptEmployeesListJson
            .map((employeeEntity) =>
                EmployeeModel.fromJson(employeeEntity).toEmployeeEntity())
            .toList();
        return deptEmployeesList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        employeesByManagerApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data['MY_TEAM'] != null) {
        if (response.data?['MY_TEAM'] != null) {
          var deptEmployeesListJson = response.data['MY_TEAM'] as List;
          var deptEmployeesList = deptEmployeesListJson
              .map((employeeEntity) =>
                  EmployeeModel.fromJsonMyTeam(employeeEntity)
                      .toEmployeeEntity())
              .toList();
          return deptEmployeesList;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<LeaveDetailsEntity>> getLeaves(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      List<dynamic>? leavesListJson;
      if (response.data?['LeaveDetails'] != null) {
        leavesListJson = response.data['LeaveDetails'] as List;
      } else if (response.data?['LeavesList'] != null) {
        leavesListJson = response.data['LeavesList'] as List;
      }
      if (leavesListJson != null) {
        var leavesList = leavesListJson
            .map((leaveJson) =>
                LeavesModel.fromJson(leaveJson).toLeaveDetailsEntity())
            .toList();
        return leavesList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<HrApprovalEntity>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        hrApprovalListApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['NotificationList'] != null) {
        var hrApprovalsJson = response.data['NotificationList'] as List;
        var hrApprovalList = hrApprovalsJson
            .map((hrApprovalJson) =>
                HrApprovalModel.fromJson(hrApprovalJson).toHrApprovalEntity())
            .toList();
        return hrApprovalList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<HrapprovalDetailsEntity> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        hrApprovalDetailsApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse = HrApprovalDetailsModel.fromJson(response.data)
          .toHrapprovalDetailsEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LeaveSubmitResponseModel>> submitHrApproval(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        submitHrApprovalApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = ApiResponse<LeaveSubmitResponseModel>.fromJson(
          response.data,
          (p0) => LeaveSubmitResponseModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ThankyouEntity>> getThankyouList(
      {required Map<String, dynamic> requestParams}) async {
    final thankyouListType = requestParams['thankyou_type'];
    final apiurl = thankyouListType == ThankyouListType.received
        ? thankYouReceivedApiUrl
        : thankYouGrantedApiUrl;
    requestParams.remove('thankyou_type');
    try {
      var response = await dio.get(
        apiurl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      final jsonListName = thankyouListType == ThankyouListType.received
          ? 'ReceivedList'
          : 'GrantedList';
      if (response.data?[jsonListName] != null) {
        var thankyouListJson = response.data[jsonListName] as List;
        var thankyouList = thankyouListJson
            .map((thankyouJson) =>
                ThankyouModel.fromJson(thankyouJson).toThankyouEntity())
            .toList();
        return thankyouList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<PayslipEntity> getPayslipDetails(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        payslipsApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse = PayslipModel.fromJson(response.data).toPayslipEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WorkingDaysEntity> getWorkingDays(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        workingDaysApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse =
          LeavesModel.fromWorkingDaysJson(response.data).toWorkingDaysEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FinanceApprovalEntity>> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      final jsonListname = apiUrl == financePOApiUrl
          ? 'PODtls'
          : apiUrl == financePRApiUrl
              ? 'PRDtls'
              : apiUrl == financeInvoiceApiUrl
                  ? 'INVDtls'
                  : 'Approvals';
      if (response.data?[jsonListname] != null) {
        var financeApprovalListJson = response.data[jsonListname] as List;
        var financeApprovalList = financeApprovalListJson
            .map((financeApprovalJson) =>
                FinanceApprovalModel.fromJson(financeApprovalJson)
                    .toFinanceApprovalEntity())
            .toList();
        return financeApprovalList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<HrapprovalDetailsEntity> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse = HrApprovalDetailsModel.fromJson(response.data)
          .toHrapprovalDetailsEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<RequestsCountEntity> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        requestsCountApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse =
          RequstsCountModel.fromJson(response.data).toRequstsCountEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<FinanceApprovalEntity>> getNotificationsList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        notificationsListApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['Notifications'] != null) {
        var financeApprovalListJson = response.data['Notifications'] as List;
        var financeApprovalList = financeApprovalListJson
            .map((financeApprovalJson) =>
                FinanceApprovalModel.fromJson(financeApprovalJson)
                    .toFinanceApprovalEntity())
            .toList();
        return financeApprovalList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<EventsEntity>> getHolidaysList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        holidayEventsApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['Holidays'] != null) {
        var holidaysListJson = response.data['Holidays'] as List;
        var holidaysList = holidaysListJson
            .map((holidaysJson) => EventModel.fromHolidaysJson(holidaysJson)
                .toHolidaysEventsEntity())
            .toList();
        return holidaysList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<String> sendPushNotifications(
      {required Map<String, dynamic> requestParams}) async {
    AccessToken? accessToken = ConstantConfig.fcmAccessTokenJson;
    if (accessToken == null || accessToken.hasExpired) {
      accessToken = await getFCMAccessToken();
      ConstantConfig.fcmAccessTokenJson = accessToken;
    }
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlFirebase;
    try {
      var response = await dio2.post(
        firebaseApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${accessToken.data}',
        }),
        data: jsonEncode(requestParams),
      );
      switch (response.statusCode) {
        case 200:
          return 'Send Successfully';
        default:
          throw _getExceptionType(response);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        submitJobEmailApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = response.data;
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<WeatherEntity> getWeatherReport(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = 'https://api.open-meteo.com/v1/forecast';
    try {
      var response = await dio2.get(
        '',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );

      if (response.data?['current_weather'] != null) {
        var weatherJson = response.data['current_weather'];
        var weatherEntity =
            WeatherModel.fromJson(weatherJson).toWeatherEntity();
        return weatherEntity;
      } else {
        return WeatherEntity();
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<List<WarningListEntity>> getWarningList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        warningListApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['WarningList'] != null) {
        var warningListJson = response.data['WarningList'] as List;
        var warningsList = warningListJson
            .map((warningJson) =>
                WarningListModel.fromJson(warningJson).toWarningListEntity())
            .toList();
        return warningsList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<InvoiceListEntity>> getInvoicesList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        invoiceListApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['InvoiceList'] != null) {
        var invoiceListJson = response.data['InvoiceList'] as List;
        var invoiceList = invoiceListJson
            .map((invoiceJson) =>
                InvoiceListModel.fromJson(invoiceJson).toInvoiceListEntity())
            .toList();
        return invoiceList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<List<FinanceApprovalEntity>> getRequestsList(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        requestsListApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data?['Notifications'] != null) {
        var financeApprovalListJson = response.data['Notifications'] as List;
        var financeApprovalList = financeApprovalListJson
            .map((financeApprovalJson) =>
                FinanceApprovalModel.fromJson(financeApprovalJson)
                    .toFinanceApprovalEntity())
            .toList();
        return financeApprovalList;
      } else {
        return [];
      }
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<RequestDetailsEntity> getRequestlDetails(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        requestsDetailsApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      var apiResponse =
          RequestsDetailsModel.fromJson(response.data).toRequestDetailsEntity();
      return apiResponse;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future get(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        queryParameters: requestParams,
      );
      return response.data;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future post(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(apiUrl, data: jsonEncode(requestParams));
      return response.data;
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }

  @override
  Future<AccessToken> getFCMAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials(
        'firebase-adminsdk-98xin@malomati-bf7ab.iam.gserviceaccount.com',
        ClientId('105305531494607984685'),
        '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC+QIerR5t3sniZ\nFOeaqxt55yAV327CDri5t/Oyrc5J6eE7AF93TpIRN2oKz5HsG0e4Xqa8Eu2Yt87h\nwVZ0F1BhFJKmHNlWpVv+gxZ5oAMIPlrneImpYLOdSi8aeUqIdFzMRi/BRIa7bMji\nOwn4+jkee8GI9Hsia0pEHXCaLoKP1O+T9KcQHQBtHVeDr19hK5XsNKv1HONafx1A\n0H6ZHnf3epvjIHxyRyAOL/2zemGn9jNVpUiUW7xx2epOYrx7zf87dFojmDTSnJfQ\ndUw5Fhg1smNi1M/FD/j1fqYVOR4NuXP/c6407fb9SULtOE+VFDGNP6zJ/imUlCi9\ni9TrTMdhAgMBAAECggEAAgZay0pgT7ZRDUQJMP64NKRulX0Cx0Lz2VopWFH8O5In\nKQMYgQMPj+pYkRPjeDFUIpSzTpYe/DyckY+GtYaX/uiCpQzyjTcGUx+fCh1XWuua\n+RKx2GEkmDx1YuE+l1QxtqTalkJ98pm2S54YPZOgLwBfL292rgeZSz9K9wEet5wm\nVx/Y4oby9WaPNgMr+5PVBchOO+/ILaJWBGRCkSrqlutjoT2oxB7vXvELYDoPHlEy\n8M4MdnPuH9/+Y0kpom1e2mNtJQdn57HGwvkWz6+g32jbtBiamE5W9fAvPhDteC1y\ntW9hkJPOg2rni7p4Hm3AacMTFmxqaBlT63ejnNQGSQKBgQDxgdOv2YrkK7f937lW\n3nRjBERoAnqT9TvhErDjfvMfXPUQlX+d8cuPUQrkNbmKeab3TXtRMtvUX8GOGzKq\nTRI0ggN14esmUmuBUhDfl4XK/iYVioaJ1Us5nOONN86lRAyJBYz5CIK+/keSLRav\nZ8LhJOJDhTxPTI3BtPkWjxSq9QKBgQDJq0r8lMYMtklqUFKGfgMi5fujGhVUkJD9\nJt1ffLi9aYgYYGyQxfXJrEr4XALHQr8VIDU+8z93GTVxM4lJkgMTTOHsWParXf3n\nbEeCL0Hrkwk8D50dC961VZ3Ik/LPAAaDhJqM0OSrtdC0vTCL2DchPW1ul1Yxccei\nYhsQZv7/PQKBgD7ysfRx5WvXoVuAxtRHo1pzsEjT7JNIJlViA80oN8KC/jVWYi8O\n6Rnv68DT6AqZ7tUi0vO1J+tREigyGqCc+hPJl5FQU3RnozHP7Cn7WpowaEjRFIQ0\nnijkJcOXOjuFYycL1VTLzRhvOsR1ECakCv2YGYmz3qZks8Y7n3krzh1JAoGAUEY9\n4BK8Tv0Udhwo7V4lk3OmWcMdMH8nJ42b2tGDm+nxAXsIXAxgjPlnEjtV48k+1ILw\njvE2lwrSyg+wmzdiwAD/gRvcfFQ6qC7ivABhpgruRxkT+ibqbJX664dwxFMHRLy4\n5EqWa39A52DTfScAstuHvtjAt4fJ5mpUyY+l+yUCgYEAswzkl13LpuHJJ3Uw3bQi\n9jrhOnNIx5lFiplePA/xf5pqrfyiuK4kC+x5+P0dDtim6rAu2KCe+ykIPoUhuBi3\nIruY5lqD6+USxgRoKl4WRHieWA8RtoSDqbUs/R12wVYSHyOnKWAxKrBibzZl/hO9\noVHxdbgy8tbDuXHBT8R7XmE=\n-----END PRIVATE KEY-----\n',
      ),
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    final accessToken = client.credentials.accessToken;
    return accessToken;
  }
}
