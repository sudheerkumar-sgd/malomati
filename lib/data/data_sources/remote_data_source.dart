import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/model/Leaves_model.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/data/model/dashboard_model.dart';
import 'package:malomati/data/model/employee_model.dart';
import 'package:malomati/data/model/event_list_model.dart';
import 'package:malomati/data/model/hr_approval_model.dart';
import 'package:malomati/data/model/leave_submit_response_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/data/model/profile_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import '../../config/base_url_config.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/employee_entity.dart';
import '../model/attendance_List_model.dart';
import 'api_urls.dart';
import 'dio_logging_interceptor.dart';

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
  Future<ApiResponse<DashboardModel>> getDashboardData(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<EventListModel>> getEventsData(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitLeaveRequest(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<LeaveSubmitResponseModel>> submitServicesRequest(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<List<EmployeeEntity>> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams});
  Future<List<EmployeeEntity>> getEmployeesByManager(
      {required Map<String, dynamic> requestParams});
  Future<List<NameIdEntity>> getLeaves(
      {required Map<String, dynamic> requestParams});
  Future<List<HrApprovalEntity>> getHrApprovalsList(
      {required Map<String, dynamic> requestParams});
  Future<List<HrApprovalEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams});
  Future<ApiEntity> submitHrApproval(
      {required Map<String, dynamic> requestParams});
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
      var response = await dio2.get(
        '${attendanceApiUrl}date-range=${requestParams['date-range']}$attendanceRequestedParams',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

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
      var response = await dio2.get(
        '${attendanceDetailsApiUrl}date-range=${requestParams['date-range']}$attendanceDetailsRequestedParams',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

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
  Future<String> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var query =
          'userid=${requestParams['userid']};event-datetime=${requestParams['date']};in-out=${requestParams['isInOut']};dtype=12;did=1;gps_latitude=${requestParams['latitude']};gps_longitude=${requestParams['longitude']};spfid=${requestParams['method']}';
      var response = await dio2.get(
        '$attendanceSubmitApiUrl$query',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

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
      if (response.data['DeptEmployeesList'] != null) {
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
        var deptEmployeesListJson = response.data['MY_TEAM'] as List;
        var deptEmployeesList = deptEmployeesListJson
            .map((employeeEntity) =>
                EmployeeModel.fromJsonMyTeam(employeeEntity).toEmployeeEntity())
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
  Future<List<NameIdEntity>> getLeaves(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        leavesApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data['LeaveDetails'] != null) {
        var leavesListJson = response.data['LeaveDetails'] as List;
        var deptEmployeesList = leavesListJson
            .map(
                (leaveJson) => LeavesModel.fromJson(leaveJson).toNameIdEntity())
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
      if (response.data['NotificationList'] != null) {
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
  Future<List<HrApprovalEntity>> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        hrApprovalDetailsApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );
      if (response.data['NotificationDetails'] != null) {
        var hrApprovalsJson = response.data['NotificationDetails'] as List;
        var hrApprovalList = hrApprovalsJson
            .map((hrApprovalJson) =>
                HrApprovalModel.fromJsonDetails(hrApprovalJson)
                    .toHrApprovalDetailsEntity())
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
  Future<ApiEntity> submitHrApproval(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(
        submitHrApprovalApiUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );
      var apiResponse = ApiResponse<BaseModel>.fromJson(response.data, null);
      return apiResponse.toApiEntity();
    } on DioException catch (e) {
      printLog(message: e.toString());
      rethrow;
    }
  }
}
