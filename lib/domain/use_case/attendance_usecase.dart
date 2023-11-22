import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';
import '../entities/attendance_list_entity.dart';

class AttendanceUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  AttendanceUseCase({required this.apisRepository});

  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceReport(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getAttendance(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getAttendanceDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, String>> submitAttendanceDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitAttendanceDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<AttendanceUserDetailsEntity>>>
      getUserDetails({required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getAttendanceUserDetails(
        requestParams: requestParams);
  }
}
