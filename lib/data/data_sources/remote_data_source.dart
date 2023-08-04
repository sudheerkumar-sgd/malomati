import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/attendance_model.dart';
import 'package:malomati/data/model/dashboard_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/data/model/profile_model.dart';
import '../../config/base_url_config.dart';
import '../../config/constant_config.dart';
import '../../core/error/exceptions.dart';
import 'dio_logging_interceptor.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<LoginModel>> login(
      {required apiPath, required Map<String, dynamic> requestParams});
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<AttendanceModel>> getAttendance(
      {required Map<String, dynamic> requestParams});
  Future<ApiResponse<DashboardModel>> getDashboardData(
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
        'UAQSGD_MOB_ERP_GetProfile/GetProfile',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(requestParams),
      );

      var apiResponse = ApiResponse<LoginModel>.fromJson(
          response.data, (p0) => LoginModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      // Something happened in setting up or sending the request that triggered an Error
      rethrow;
    }
  }

  @override
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        'Profile',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );

      switch (response.statusCode) {
        case 200:
          var apiResponse = ApiResponse<ProfileModel>.fromJson(
              response.data, (p0) => ProfileModel.fromJson(response.data));
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
  Future<ApiResponse<AttendanceModel>> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrlAttendanceDevelopment;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2.get(
        'attendance-daily?action=get;format=json;date-range=${requestParams['date-range']};Field-name=USERID,USERNAME,PROCESSDATE,PUNCH1_TIME,PUNCH2_TIME,PUNCH3_TIME,PUNCH4_TIME,PUNCH5_TIME,PUNCH6_TIME,PUNCH7_TIME,PUNCH8_TIME,PUNCH9_TIME,PUNCH10_TIME,WORKTIME_HHMM,FIRSTHALF,SECONDHALF,SPFID1,SPFID2,SPFID3,SPFID4,SPFID5,SPFID6,SPFID7,SPFID8,SPFID9,SPFID10',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      switch (response.statusCode) {
        case 200:
          var apiResponse = ApiResponse<AttendanceModel>.fromJson(
              response.data, (p0) => AttendanceModel.fromJson(response.data));
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
  Future<ApiResponse<DashboardModel>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        'UAQSGD_MOB_ERP_EmployeeDashboard/LeavesAndThankyouCount',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        queryParameters: requestParams,
      );

      var apiResponse = ApiResponse<DashboardModel>.fromJson(
          response.data, (p0) => DashboardModel.fromJson(response.data));
      return apiResponse;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
