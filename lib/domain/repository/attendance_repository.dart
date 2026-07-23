import 'package:dartz/dartz.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';

import '../entities/attendance_list_entity.dart';

/// Attendance API + generic GET/POST for attendance subsystem.
abstract class AttendanceRepository {
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>>
      getEmployeesAttendanceReport(
          {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceDetails(
      {String? apiUrl, required Map<String, dynamic> requestParams});
  Future<Either<Failure, String>> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceUserDetailsEntity>>>
      getAttendanceUserDetails(String apiUrl,
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
