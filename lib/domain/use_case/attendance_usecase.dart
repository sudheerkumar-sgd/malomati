import 'package:dartz/dartz.dart';
import 'package:malomati/config/base_url_config.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/attendance_model.dart';
import 'package:malomati/data/model/response_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/repository/attendance_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';
import '../entities/attendance_list_entity.dart';

class AttendanceUseCase extends BaseUseCase {
  final AttendanceRepository attendanceRepository;
  AttendanceUseCase({required this.attendanceRepository});

  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceReport(
      {required Map<String, dynamic> requestParams}) async {
    return await attendanceRepository.getAttendance(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceDetails(
      {String? apiUrl, required Map<String, dynamic> requestParams}) async {
    return await attendanceRepository.getAttendanceDetails(
        apiUrl: apiUrl, requestParams: requestParams);
  }

  Future<Either<Failure, String>> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await attendanceRepository.submitAttendanceDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<AttendanceUserDetailsEntity>>>
      getUserDetails(String apiUrl,
          {required Map<String, dynamic> requestParams}) async {
    return await attendanceRepository.getAttendanceUserDetails(apiUrl,
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<BaseEntity>>> submitOfficialInReason(
      {required Map<String, dynamic> requestParams}) async {
    var apiResponse = await attendanceRepository.post<ResponseModel>(
      apiUrl: officialInApiUrl,
      requestParams: requestParams,
      responseModel: ResponseModel.fromJson,
    );
    return apiResponse.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r.toApiEntity());
    });
  }

  Future<Either<Failure, List<LocationAccessEntity>>> getLocationMaster({
    String apiUrl = locationMasterApiUrl,
  }) async {
    final result = await attendanceRepository.get<LocationAccessListModel>(
      baseUrl: baseUrlAttendanceDevelopment,
      apiUrl: locationMasterApiUrl,
      requestParams: {},
      responseModel: LocationAccessListModel.fromJson,
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right((r.data as LocationAccessListModel?)?.locations ?? []),
    );
  }
}
